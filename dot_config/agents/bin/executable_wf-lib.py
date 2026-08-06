#!/usr/bin/env python3
"""wf-lib: shared helpers for the wf-* toolbelt. Stdlib only.

  wf-lib.py ready-set [--exclude-files GLOB,GLOB]  -> runnable ids (one/line), checkpoints flagged
  wf-lib.py get FILE KEY            -> frontmatter value (lists as JSON)
  wf-lib.py set FILE KEY VALUE      -> update frontmatter key in place
  wf-lib.py bump-attempts FILE      -> attempts += 1, prints new value
  wf-lib.py file-of ID              -> prints issue filename for id
  wf-lib.py check-schema            -> nonzero on any schema_version mismatch
  wf-lib.py summary                 -> status table
  wf-lib.py all-done                -> exit 0 if every issue is done
"""
import sys, re, json, fnmatch
from pathlib import Path

SCHEMA_VERSION = 2
ISSUES = Path(".claude/issues")

def parse_frontmatter(path: Path) -> dict:
    m = re.match(r"^---\n(.*?)\n---\n", path.read_text(), re.DOTALL)
    if not m:
        raise ValueError(f"{path}: no frontmatter block")
    fm, key = {}, None
    for line in m.group(1).splitlines():
        if re.match(r"^\s*-\s+", line) and key:
            fm.setdefault(key, [])
            if isinstance(fm[key], list):
                fm[key].append(line.split("-", 1)[1].strip().strip('"'))
            continue
        kv = re.match(r"^(\w+):\s*(.*)$", line)
        if kv:
            key, raw = kv.group(1), kv.group(2).strip()
            if raw.startswith("[") and raw.endswith("]"):
                fm[key] = [x.strip().strip('"') for x in raw[1:-1].split(",") if x.strip()]
            elif raw == "":
                fm[key] = []
            else:
                fm[key] = raw.strip('"')
    return fm

def set_key(path: Path, k: str, v: str):
    text = path.read_text()
    new, n = re.subn(rf"^({k}):\s*.*$", rf"\1: {v}", text, count=1, flags=re.MULTILINE)
    if n == 0:
        sys.exit(f"wf-lib: key '{k}' not found in {path}")
    path.write_text(new)

def load_issues():
    if not ISSUES.is_dir():
        sys.exit("wf-lib: no .claude/issues here — wrong directory, or spec hasn't run")
    out = {}
    for p in sorted(ISSUES.glob("[0-9]*.md")):
        out[parse_frontmatter(p)["id"]] = p
    return {i: (p, parse_frontmatter(p)) for i, p in out.items()}

def overlaps(globs_a, globs_b):
    # conservative: any pattern-vs-pattern match either direction counts as overlap
    for a in globs_a:
        for b in globs_b:
            if fnmatch.fnmatch(a, b) or fnmatch.fnmatch(b, a) or a == b:
                return True
    return False

def ready_set(exclude_files):
    issues = load_issues()
    done = {i for i, (_, fm) in issues.items() if fm.get("status") == "done"}
    out = []
    for i, (p, fm) in issues.items():
        if fm.get("status") not in ("ready", "backlog"):
            continue
        if not all(b in done for b in fm.get("blocked_by", [])):
            continue
        if exclude_files and overlaps(fm.get("files", []), exclude_files):
            continue
        out.append((i, fm.get("type", "task"), p.name))
    return out

def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
    if cmd == "ready-set":
        excl = []
        if len(sys.argv) > 3 and sys.argv[2] == "--exclude-files":
            excl = [g for g in sys.argv[3].split(",") if g]
        for i, typ, name in ready_set(excl):
            print(f"{i}\t{typ}\t{name}")
    elif cmd == "get":
        v = parse_frontmatter(Path(sys.argv[2])).get(sys.argv[3], "")
        print(json.dumps(v) if isinstance(v, list) else v)
    elif cmd == "set":
        set_key(Path(sys.argv[2]), sys.argv[3], sys.argv[4])
    elif cmd == "bump-attempts":
        p = Path(sys.argv[2])
        n = int(parse_frontmatter(p).get("attempts", "0")) + 1
        set_key(p, "attempts", str(n)); print(n)
    elif cmd == "file-of":
        issues = load_issues()
        tid = sys.argv[2]
        if tid not in issues:
            sys.exit(f"wf-lib: no issue {tid}")
        print(issues[tid][0].name)
    elif cmd == "check-schema":
        bad = [str(p) for _, (p, fm) in load_issues().items()
               if int(fm.get("schema_version", "0")) != SCHEMA_VERSION]
        if bad:
            sys.exit("wf-lib: schema_version mismatch (want %d):\n  %s"
                     % (SCHEMA_VERSION, "\n  ".join(bad)))
    elif cmd == "all-done":
        sys.exit(0 if all(fm.get("status") == "done"
                          for _, (_, fm) in load_issues().items()) else 1)
    elif cmd == "summary":
        for i, (p, fm) in load_issues().items():
            blk = ",".join(fm.get("blocked_by", [])) or "-"
            print(f"{i}  {fm.get('status','?'):11s} {fm.get('type','task'):10s} "
                  f"att:{fm.get('attempts','0'):>2s}  blk:{blk:12s} {fm.get('title','')}")
    else:
        print(__doc__)

if __name__ == "__main__":
    main()
