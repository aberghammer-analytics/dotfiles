# Python idioms

- uv for everything: `uv run`, `uv add`, `uv sync`. Never pip
- ruff for lint and format
- `ruff format` to format, `ruff check --fix` to lint. Both must be clean before commit
- pydantic models where possible
- pytest only
- use `pathlib` everywhere. No os.path
- prefer stdlib over adding a dependency
- logging over print
- never use `from __future__ import annotations` unless absolutely necessary
- hatchling as the build backend
