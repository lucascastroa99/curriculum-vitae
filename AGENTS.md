# AGENTS.md

## Project Overview

Bilingual (PT-BR / EN-US) curriculum vitae generation system. Data-driven architecture using YAML source files rendered into Markdown and PDF outputs via Nunjucks and Typst templates.

**Core purpose**: Maintain a single source of truth for resume, cover letter, and email content in YAML; generate all output formats from that data.

## Architecture

```
data/*.yaml  →  templates/*.njk  →  output/*.md   (Node.js + Nunjucks)
data/*.yaml  →  templates/*.typ  →  output/*.pdf   (Typst CLI)
```

- **Data layer**: YAML files define all personal info, experience, education, skills, cover letter paragraphs, and email templates
- **Template layer**: Nunjucks (`.njk`) for Markdown, Typst (`.typ`) for PDF
- **Build layer**: `scripts/generate-markdown.js` handles Markdown generation; Typst CLI handles PDF compilation
- **Output layer**: All generated files (`.md` and `.pdf`) live in `output/`

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
- Node.js (for Markdown generation)
- pnpm (package manager)
- Typst CLI (for PDF compilation)

### Build Commands

```bash
# Install dependencies
pnpm install

# Build all outputs (PDFs + Markdown, both languages)
pnpm run build:all

# Build specific document type in both languages
pnpm run build:resume:en    # English resume (PDF + MD)
pnpm run build:resume:pt    # Portuguese resume (PDF + MD)
pnpm run build:cover-letter:en
pnpm run build:cover-letter:pt
pnpm run build:email:en
pnpm run build:email:pt
```

### Watch Mode

```bash
# Watch and auto-rebuild PDFs on file changes
pnpm run watch:resume:en
pnpm run watch:resume:pt
pnpm run watch:cover-letter:en
pnpm run watch:cover-letter:pt
```

### Markdown Generation (standalone)

```bash
# Generate Markdown only (no PDF)
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
- PDF-only output (no Markdown counterpart for Typst)
- Compiled with `typst compile --root .`

## Code Style

- JavaScript (CommonJS): `scripts/generate-markdown.js`
- No linting or formatting tools configured
- YAML: standard 2-space indentation
- Nunjucks: follow existing macro patterns in `common.njk`

## Agent Rules

- **Never edit files in `output/`** — they are generated artifacts
- **Edit YAML data files** to change content, not templates or output
- **Test builds** after modifying templates or data: `pnpm run build:all`
- **Respect bilingual structure** — all new fields should support `en`/`pt` when applicable
- **YAML data integrity** — validate YAML syntax before committing
- **Template filters** — use existing filters (`field`, `phone`, `formatDate`, `skillDetails`); add new filters to `generate-markdown.js` if needed
- **Typst vs Nunjucks** — Typst generates PDFs, Nunjucks generates Markdown; they are independent pipelines

## Additional Notes

- No test suite exists — verify builds manually after changes
- No CI/CD pipeline configured
- No `.env` or environment-specific configuration
- Git history shows conventional commits (`feat(cv):`, `docs:`) — follow this pattern
- PDF outputs include both standard and LinkedIn-optimized variants (separate filenames)
- The `pnpm-lock.yaml` is committed — always use `pnpm install` (not npm)
