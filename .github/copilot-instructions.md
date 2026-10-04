# Copilot Instructions for r-stories-mfe

## Build, Test, and Lint

### Development
```bash
yarn dev          # Start dev server on port 5174
yarn build        # Full build: TypeScript check + Vite bundle
yarn lint         # Run ESLint on all TypeScript/TSX files
yarn preview      # Preview the production build locally
```

**Quick checks:**
- `yarn lint` - Run ESLint on the entire project
- `tsc -b` - TypeScript check only (used in build pipeline)

## Architecture Overview

**What this project is:** A React micro frontend (MFE) using Module Federation that showcases R code examples organized by category. Stories are defined in markdown and compiled at build time.

**Key flows:**
1. **Story Loading (Build Time):** Vite globs load all `story.md`, `*.R`, and image files from the `src/stories/` directory tree
2. **Story Parsing:** `parseMarkdownStory.ts` extracts frontmatter (id, title, category, description) and H2-delimited variants from markdown
3. **Variant Structure:** Each variant contains a title, optional description, R code block, and image reference
4. **Navigation:** React Router manages URL paths like `/{story-id}/{variant-id}`; URL syncing ensures the UI stays in sync via `useEffect` hooks
5. **Code Display:** Shiki (syntax highlighter) renders R code with HTML; `highlightCode()` is async and cached via state
6. **Module Federation:** App.tsx is exported as `./App` so external apps can consume this MFE as a remote

**Asset Resolution:**
- Images and R code files are resolved dynamically at build time via `import.meta.glob` with eager loading
- Fallback console warnings when an asset is not found (e.g., image reference in story doesn't exist in disk)

## Key Conventions

### Story File Structure
Stories live in `src/stories/{category}/{name}/` with this layout:
```
src/stories/
├── plots/
│   ├── scatter/
│   │   ├── story.md          # Frontmatter + variant sections (H2)
│   │   ├── scatter-basic.png # Images referenced in story.md
│   │   └── scatter-plot.R    # Optional: R code files (reference via !r(filename.R))
```

**Story Markdown Format:**
```markdown
---
id: plots/scatter
title: Scatter Plot
category: Plots
description: Optional story-level description
---

## Basic

Optional variant description.

```r
library(ggplot2)
ggplot(mtcars, aes(wt, mpg)) + geom_point()
```

![](./scatter-basic.png)

## Colored

Another variant...
```r
...
```

![](./scatter-colored.png)
```

**Key parsing rules:**
- Frontmatter is YAML-like (key: value pairs between `---` markers)
- Variants are H2 sections; first line becomes the variant title
- Code blocks (triple backticks) are required for each variant
- Image references use markdown syntax `![](./filename.png)` and must exist
- Code can be inline or reference external `.R` files via `!r(filename.R)`

### CSS Scoping
All styles use the `--mfe-template-*` CSS custom property namespace to avoid conflicts with host apps or other MFEs. Class names follow BEM with the `.mfe-template` block prefix:
- `.mfe-template__center` (element inside the root)
- `.mfe-template__sidebar` (another element)

**Avoid:**
- Generic IDs (#center, #docs) — use scoped classes instead
- Bare CSS variables — always use `--mfe-template-*` prefix

### TypeScript Configuration
- Target: `es2023` with `esnext` modules (modern bundler mode)
- Strict linting enabled: `noUnusedLocals`, `noUnusedParameters`, `noFallthroughCasesInSwitch`
- JSX: React 17+ `react-jsx` transform (no `React` import needed)

### Markdown Parsing
- `parseMarkdownStory()`: Parses story markdown files into Story/StoryVariant objects
- `parseInlineMarkdown()`: Converts inline markdown (`**bold**`, `*italic*`, `` `code` ``, `[link](url)`) to HTML for descriptions
- These run at build time for story.md and at runtime for user descriptions

## Deployment

The project deploys to GitHub Pages via GitHub Actions on every push to `main`. The workflow:
1. Installs dependencies with `yarn install --frozen-lockfile`
2. Runs `yarn build`
3. Uploads the `dist/` directory as a GitHub Pages artifact

Deployment is automatic; no manual steps required.
