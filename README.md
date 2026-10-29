# mtdefelice.github.io

Plain-text and PDF curriculum vitae / resume for Michael DeFelice, served via GitHub Pages at [https://mtdefelice.github.io](https://mtdefelice.github.io).

## Overview

The canonical resume content lives in `cv-mtdefelice.txt` at the repository root, with historical snapshots stored in `archive/`. From that single plain-text source of truth, `Makefile` generates:
1. **`index.html`**: Minimal HTML5 document with `<pre style="white-space: pre-wrap;">`, SEO metadata, and Schema.org `Person` JSON-LD structured data.
2. **`cv-mtdefelice.pdf`**: ATS-friendly executive PDF compiled via [Typst](https://typst.app/) (`src/cv.typ`), which parses `cv-mtdefelice.txt` directly.

## Repository Structure

- `cv-mtdefelice.txt` — Active plain-text resume source of truth.
- `cv-mtdefelice.pdf` — Generated PDF built from `cv-mtdefelice.txt`.
- `index.html` — Generated HTML entrypoint served by GitHub Pages.
- `src/cv.typ` — Typst template and parser that renders `cv-mtdefelice.txt` into a styled PDF.
- `archive/cv-mtdefelice_<YEAR>.txt` — Historical plain-text resume revisions (`2019`, `2020`, `2021`, `2025`).
- `Makefile` — Builds `index.html` and `cv-mtdefelice.pdf` from `cv-mtdefelice.txt`, validates outputs, and serves local previews.

## Usage

### Build Everything (`index.html` + PDF)

After editing `cv-mtdefelice.txt`, regenerate both `index.html` and `cv-mtdefelice.pdf`:

```bash
make
# or individually:
make html
make pdf
```

When archiving the current resume before a new year's revision:

```bash
cp cv-mtdefelice.txt archive/cv-mtdefelice_<YEAR>.txt
```

### Validate Build & Metadata

Verify that `index.html` is in sync with `cv-mtdefelice.txt`, the embedded JSON-LD structured data is valid JSON, and `cv-mtdefelice.pdf` is a valid PDF:

```bash
make check
```

### Local Preview

Serve the repository locally at `http://localhost:8000`:

```bash
make serve
```

## Deployment

GitHub Pages serves the root of the `master` branch directly:
- HTML view: `https://mtdefelice.github.io/`
- Raw plain-text view (latest): `https://mtdefelice.github.io/cv-mtdefelice.txt`
- PDF view (latest): `https://mtdefelice.github.io/cv-mtdefelice.pdf`

Commit the updated `cv-mtdefelice.txt` source file and regenerated `index.html` / `cv-mtdefelice.pdf` artifacts before pushing.
