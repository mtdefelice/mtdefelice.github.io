SHELL := /usr/bin/env bash
.SHELLFLAGS := -euo pipefail -c

SRC ?= cv-mtdefelice.txt
OUT ?= index.html
PDF ?= cv-mtdefelice.pdf
TYP_SRC ?= src/cv.typ
TYPST ?= $(shell command -v typst 2>/dev/null || echo "$$HOME/.local/bin/typst")

define HTML_HEADER
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Resume for Michael DeFelice - a hands-on technology leader, Co-Founder, and CTO with 20+ years of experience in product incubation, applied data science &amp; AI/ML, technical due diligence, and systems architecture.">
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Michael DeFelice",
  "jobTitle": "Co-Founder & Technical Partner",
  "address": {
    "@type": "PostalAddress",
    "addressRegion": "TX",
    "addressCountry": "US"
  },
  "alumniOf": {
    "@type": "CollegeOrUniversity",
    "name": "Ursinus College"
  },
  "url": "https://mtdefelice.github.io",
  "sameAs": [
    "https://github.com/mtdefelice",
    "https://www.linkedin.com/in/mtdefelice"
  ]
}
</script>
<title>Michael DeFelice</title>
</head>
<body>
<pre style="white-space: pre-wrap;">
endef

define HTML_FOOTER
</pre>
</body>
</html>
endef

export HTML_HEADER
export HTML_FOOTER

.PHONY: all build html pdf check serve

all: build

build: html pdf

html: $(OUT)

pdf: $(PDF)

$(OUT): $(SRC) Makefile
	@tmp="$$(mktemp "$(OUT).tmp.XXXXXX")"; \
	trap 'rm -f "$$tmp"' EXIT; \
	printf '%s\n' "$$HTML_HEADER" > "$$tmp"; \
	sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' "$(SRC)" >> "$$tmp"; \
	if [[ -n "$$(tail -c 1 "$$tmp")" ]]; then echo "" >> "$$tmp"; fi; \
	printf '%s\n' "$$HTML_FOOTER" >> "$$tmp"; \
	chmod 0644 "$$tmp"; \
	mv "$$tmp" "$(OUT)"
	@echo "Built $(OUT) from $(SRC)"

$(PDF): $(SRC) $(TYP_SRC) Makefile
	@tmp="$$(mktemp "$(PDF).tmp.XXXXXX")"; \
	trap 'rm -f "$$tmp"' EXIT; \
	"$(TYPST)" compile --root . --format pdf --input src="$(SRC)" "$(TYP_SRC)" "$$tmp"; \
	chmod 0644 "$$tmp"; \
	mv "$$tmp" "$(PDF)"
	@echo "Built $(PDF) from $(SRC)"

check:
	@tmp="$$(mktemp "$(OUT).check.XXXXXX")"; \
	tmp_pdf="$$(mktemp "$(PDF).check.XXXXXX")"; \
	trap 'rm -f "$$tmp" "$$tmp_pdf"' EXIT; \
	$(MAKE) -s -B html SRC="$(SRC)" OUT="$$tmp" >/dev/null; \
	diff -u "$(OUT)" "$$tmp" || (echo "Error: $(OUT) is out of sync with $(SRC). Run 'make build'." >&2 && exit 1); \
	python3 -c 'import json, re, sys; content = open(sys.argv[1]).read(); m = re.search(r"<script type=\"application/ld\+json\">\s*(.*?)\s*</script>", content, re.S); assert m, "Missing JSON-LD"; json.loads(m.group(1)); print("OK: HTML and JSON-LD valid; $(OUT) is in sync.")' "$(OUT)"; \
	if [[ ! -f "$(PDF)" ]]; then \
		echo "Error: $(PDF) is missing. Run 'make build'." >&2; \
		exit 1; \
	fi; \
	$(MAKE) -s -B pdf SRC="$(SRC)" PDF="$$tmp_pdf" >/dev/null; \
	cmp -s "$(PDF)" "$$tmp_pdf" || (echo "Error: $(PDF) is out of sync with $(SRC) or $(TYP_SRC). Run 'make build'." >&2 && exit 1); \
	if command -v pdfinfo >/dev/null 2>&1; then \
		pages="$$(pdfinfo "$(PDF)" 2>/dev/null | awk "/^Pages:/ {print \$$2}" || true)"; \
		if [[ -z "$$pages" || "$$pages" -lt 1 ]]; then \
			echo "Error: $(PDF) has invalid page count ($$pages)." >&2; \
			exit 1; \
		fi; \
		echo "OK: $(PDF) is valid and in sync ($$pages pages)."; \
	else \
		echo "OK: $(PDF) is in sync."; \
	fi

serve: build
	python3 -m http.server 8000
