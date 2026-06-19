# AGENTS.md

## Project Overview

Bilingual (PT-BR / EN-US) curriculum vitae generation system. Data-driven architecture using YAML source files rendered into Markdown and PDF outputs via Nunjucks and Typst templates.

**Core purpose**: Maintain a single source of truth for resume, cover letter, and email content in YAML; generate all output formats from that data.

## Architecture

```
data/*.yaml  →  templates/*.njk  →  output/*.md   (Node.js + Nunjucks)
data/*.yaml  →  templates/*.typ  →  output/*.pdf   (Typst CLI)
```

- **Data layer**: YAML files define personal info, experience, education, skills, cover letter paragraphs, email templates
- **Template layer**: Nunjucks (`.njk`) for Markdown; Typst (`.typ`) for PDF
- **Build layer**: `scripts/generate-markdown.js` (Markdown); Typst CLI (PDF)
- **Output layer**: Generated `.md` and `.pdf` files in `output/` (never edit directly)

## Directory Structure

| Directory | Purpose |
|-----------|---------|
| `data/` | YAML source files (personal, resume, cover-letter, email) |
| `templates/` | Nunjucks (`.njk`) and Typst (`.typ`) templates for PT and EN |
| `scripts/` | Node.js build scripts (`generate-markdown.js`) |
| `output/` | Generated Markdown and PDF files (do not edit manually) |
| `node_modules/` | Dependencies (gitignored) |

## Development Workflow

### Prerequisites

- Node.js (v18+)
- pnpm (package manager)
- Typst CLI (for PDF compilation)

### Setup Commands

```bash
pnpm install
```

### Build Commands

```bash
pnpm run build:all                    # Build all outputs (PDF + Markdown, both languages)
pnpm run build:resume:en              # English resume (PDF + MD)
pnpm run build:resume:pt              # Portuguese resume (PDF + MD)
pnpm run build:cover-letter:en        # English cover letter (PDF + MD)
pnpm run build:cover-letter:pt        # Portuguese cover letter (PDF + MD)
pnpm run build:email:en               # English email template (MD only)
pnpm run build:email:pt               # Portuguese email template (MD only)
```

### Watch Mode (PDF only)

```bash
pnpm run watch:resume:en
pnpm run watch:resume:pt
pnpm run watch:cover-letter:en
pnpm run watch:cover-letter:pt
```

### Standalone Markdown Generation

```bash
node scripts/generate-markdown.js --type=<cover|resume|email> [--lang=<en|pt>]
```

## Data Editing

All content lives in YAML files under `data/`. Edit these files — never edit output files directly.

- `data/personal.yaml` — Name, contact info, position titles
- `data/resume.yaml` — Summary, experience, projects, education, certifications, skills, languages
- `data/cover-letter.yaml` — Cover letter paragraphs (per language)
- `data/email.yaml` — Email subject and body templates (per language)

### Bilingual Field Pattern

Most fields use an object with `en` and `pt` keys:

```yaml
position:
  en: Full Stack Developer
  pt: Desenvolvedor Full Stack
```

Simple string fields are language-agnostic. Use the `field(lang)` Nunjucks filter to select the correct language.

## Template Conventions

### Nunjucks Templates (`.njk`)

- Located in `templates/`
- Shared macros live in `common.njk`
- Custom filters: `field`, `phone`, `formatDate`, `skillDetails`
- Language selection via `lang` variable passed at render time

### Typst Templates (`.typ`)

- Located in `templates/`
- PDF-only output (no Markdown counterpart)
- Compiled with `typst compile --root .`
- Shared styles in `common.typ`

## Testing Instructions

No automated test suite exists. Verify builds manually after changes:

```bash
pnpm run build:all
```

Check output files in `output/` for correct rendering. Verify both languages render correctly.

## Code Style and Conventions

- **JavaScript**: CommonJS (`scripts/generate-markdown.js`)
- **YAML**: 2-space indentation
- **Nunjucks**: Follow existing macro patterns in `common.njk`
- **Typst**: Follow existing patterns in `common.typ`
- **No linting or formatting tools configured**

## Build and Deployment

- All outputs generated to `output/` directory
- PDF outputs include both standard and LinkedIn-optimized variants (separate filenames)
- No CI/CD pipeline configured
- No environment-specific configuration

## Agent Rules

- **Never edit files in `output/`** — they are generated artifacts
- **Edit YAML data files** to change content, not templates or output
- **Test builds** after modifying templates or data: `pnpm run build:all`
- **Respect bilingual structure** — all new fields should support `en`/`pt` when applicable
- **YAML data integrity** — validate YAML syntax before committing
- **Template filters** — use existing filters (`field`, `phone`, `formatDate`, `skillDetails`); add new filters to `generate-markdown.js` if needed
- **Typst vs Nunjucks** — Typst generates PDFs, Nunjucks generates Markdown; they are independent pipelines
- **Always use `pnpm install`** — the `pnpm-lock.yaml` is committed
- **Conventional commits** — follow `feat(cv):`, `docs:`, `fix:` pattern

## Debugging Notes

- **YAML parse errors**: Validate YAML syntax; use 2-space indentation
- **Missing template filters**: Add new filters in `scripts/generate-markdown.js` via `createEnv()`
- **PDF not generating**: Ensure Typst CLI is installed (`typst --version`)
- **Markdown not generating**: Ensure Node.js and pnpm are installed; run `pnpm install`

## Additional Notes

- No test suite — verify builds manually after changes
- No CI/CD pipeline
- No `.env` or environment-specific configuration
- Git history shows conventional commits (`feat(cv):`, `docs:`) — follow this pattern
