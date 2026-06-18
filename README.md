# Curriculum Vitae

Bilingual (PT-BR / EN-US) resume generation system. Edit content in YAML, generate Markdown and PDF outputs from a single source of truth.

## Features

- **Bilingual** — English (EN-US) and Portuguese (PT-BR) from the same YAML data
- **Dual Output** — Markdown (Nunjucks) and PDF (Typst) generated independently
- **Data-Driven** — all content lives in `data/*.yaml`; never edit output files directly
- **Professional Layout** — ATS-friendly PDF with clean typography via Typst
- **Version Controlled** — Git tracks every CV revision automatically

## Architecture

```
data/*.yaml  ──►  templates/*.njk  ──►  output/*.md    (Node.js + Nunjucks)
data/*.yaml  ──►  templates/*.typ  ──►  output/*.pdf    (Typst CLI)
```

| Layer | Responsibility |
|-------|---------------|
| **Data** | YAML files — personal info, resume, cover letter, email templates |
| **Templates** | Nunjucks (`.njk`) for Markdown; Typst (`.typ`) for PDF |
| **Build** | `scripts/generate-markdown.js` + `typst compile` |
| **Output** | Generated `.md` and `.pdf` files — never edit these directly |

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18+)
- [pnpm](https://pnpm.io/)
- [Typst CLI](https://typst.app/) (for PDF generation)

### Installation

```bash
pnpm install
```

## Usage

### Build Everything

```bash
pnpm run build:all
```

This generates all Markdown and PDF outputs for both languages.

### Build Individual Documents

```bash
pnpm run build:resume:en          # English resume (PDF + MD)
pnpm run build:resume:pt          # Portuguese resume (PDF + MD)
pnpm run build:cover-letter:en    # English cover letter (PDF + MD)
pnpm run build:cover-letter:pt    # Portuguese cover letter (PDF + MD)
pnpm run build:email:en           # English email template (MD only)
pnpm run build:email:pt           # Portuguese email template (MD only)
```

### Watch Mode (PDF)

```bash
pnpm run watch:resume:en
pnpm run watch:resume:pt
pnpm run watch:cover-letter:en
pnpm run watch:cover-letter:pt
```

### Markdown Only (No PDF)

```bash
node scripts/generate-markdown.js --type=<cover|resume|email> [--lang=<en|pt>]
```

## Project Structure

```
├── data/
│   ├── personal.yaml          # Name, contact info, position titles
│   ├── resume.yaml            # Summary, experience, education, skills
│   ├── cover-letter.yaml      # Cover letter paragraphs (PT + EN)
│   └── email.yaml             # Email subject and body templates
├── templates/
│   ├── common.njk             # Shared Nunjucks macros (header, resumeBody)
│   ├── common.typ             # Shared Typst styles
│   ├── resume-en.njk          # English resume → Markdown
│   ├── resume-pt.njk          # Portuguese resume → Markdown
│   ├── resume-en.typ          # English resume → PDF
│   ├── resume-pt.typ          # Portuguese resume → PDF
│   ├── cover-letter-en.njk    # English cover letter → Markdown
│   ├── cover-letter-pt.njk    # Portuguese cover letter → Markdown
│   ├── cover-letter-en.typ    # English cover letter → PDF
│   ├── cover-letter-pt.typ    # Portuguese cover letter → PDF
│   ├── email-en.njk           # English email → Markdown
│   └── email-pt.njk           # Portuguese email → Markdown
├── scripts/
│   └── generate-markdown.js   # Node.js Markdown generator
├── output/                    # Generated files (gitignored)
├── package.json
├── pnpm-lock.yaml
└── .gitignore
```

## Data Editing

Edit YAML files in `data/` to update content — all outputs regenerate from these files.

### Bilingual Fields

Most fields use an object with `en` and `pt` keys:

```yaml
position:
  en: Full Stack Developer
  pt: Desenvolvedor Full Stack
```

Simple string fields are language-agnostic.

### Data Files

| File | Contents |
|------|----------|
| `personal.yaml` | Name, email, phone, website, LinkedIn, GitHub, position titles |
| `resume.yaml` | Professional summary, work experience, projects, education, certifications, skills, languages |
| `cover-letter.yaml` | Cover letter paragraphs (per language) |
| `email.yaml` | Email subject line and body paragraphs (per language) |

## Template Filters

Custom Nunjucks filters available in templates:

| Filter | Purpose |
|--------|---------|
| `field(lang)` | Select language from bilingual object |
| `phone(lang)` | Format phone number with country code |
| `formatDate(lang)` | Format date strings (e.g., "January 2024") |
| `skillDetails(lang)` | Extract skill details by language |

## Scripts Reference

| Command | Description |
|---------|-------------|
| `pnpm run build:all` | Build all outputs (PDF + MD, both languages) |
| `pnpm run build:resume:en` | English resume (PDF + MD) |
| `pnpm run build:resume:pt` | Portuguese resume (PDF + MD) |
| `pnpm run build:cover-letter:en` | English cover letter (PDF + MD) |
| `pnpm run build:cover-letter:pt` | Portuguese cover letter (PDF + MD) |
| `pnpm run build:email:en` | English email (MD only) |
| `pnpm run build:email:pt` | Portuguese email (MD only) |
| `pnpm run watch:resume:en` | Watch English resume (PDF) |
| `pnpm run watch:resume:pt` | Watch Portuguese resume (PDF) |
| `pnpm run watch:cover-letter:en` | Watch English cover letter (PDF) |
| `pnpm run watch:cover-letter:pt` | Watch Portuguese cover letter (PDF) |

## Additional Notes

- **Never edit files in `output/`** — they are generated artifacts
- Always use `pnpm install` — the `pnpm-lock.yaml` is committed
- Follow conventional commits: `feat(cv):`, `docs:`, `fix:`
- No test suite — verify builds manually after changes
- No CI/CD pipeline configured
- PDF outputs include both standard and LinkedIn-optimized variants
