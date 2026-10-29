---
paths:
  - "**/*.{ts,tsx}"
  - "**/package.json"
  - "**/tsconfig*.json"
---

# TypeScript idioms

- pnpm for everything: `pnpm add`, `pnpm run`, `pnpm dlx`. Never npm or yarn
- Biome for lint and format. `biome check --write` before commit, `biome ci` in CI
- Node 24 LTS. Run `.ts` files directly, no tsx or ts-node
- Node strips types, it does not check them. `tsc --noEmit` in CI is not optional
- tsconfig: `strict`, `noUncheckedIndexedAccess`, `verbatimModuleSyntax`, `erasableSyntaxOnly`
- No enums, namespaces, or parameter properties. `as const` objects and union types instead
- ESM only. `import type` for type-only imports
- Zod schemas for data crossing a boundary (API, config, disk, queue). Plain interfaces for internal shapes
- Vitest only. No Jest
- `unknown` over `any`. If you need an escape hatch, narrow it immediately
- Structured logging over `console.log`
- Prefer `node:` builtins over adding a dependency
- tsdown to build a publishable library. An app needs no build step
