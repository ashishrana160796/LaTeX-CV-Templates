SHELL := /bin/zsh

TEXBIN ?= $(firstword $(wildcard /Library/TeX/texbin $(HOME)/Library/texlive/2026/bin/universal-darwin))
ifneq ($(TEXBIN),)
export PATH := $(TEXBIN):$(PATH)
endif

LATEXMK ?= latexmk
PDFTOPPM ?= pdftoppm
PDFTOTEXT ?= pdftotext

BUILD_DIR := build
DIST_DIR := dist
PREVIEW_DIR := assets/previews

DUAL_EN_PDF := $(DIST_DIR)/ashish-rana-dual-column-cv-en.pdf
DUAL_DE_PDF := $(DIST_DIR)/ashish-rana-dual-column-cv-de.pdf
SINGLE_EN_PDF := $(DIST_DIR)/ashish-rana-single-column-cv-en.pdf
SINGLE_DE_PDF := $(DIST_DIR)/ashish-rana-single-column-cv-de.pdf
PDFS := $(DUAL_EN_PDF) $(DUAL_DE_PDF) $(SINGLE_EN_PDF) $(SINGLE_DE_PDF)

PREVIEWS := \
	$(PREVIEW_DIR)/dual-column-cv-en-page-1.png \
	$(PREVIEW_DIR)/dual-column-cv-en-page-2.png \
	$(PREVIEW_DIR)/dual-column-cv-de-page-1.png \
	$(PREVIEW_DIR)/dual-column-cv-de-page-2.png \
	$(PREVIEW_DIR)/single-column-cv-en-page-1.png \
	$(PREVIEW_DIR)/single-column-cv-en-page-2.png \
	$(PREVIEW_DIR)/single-column-cv-de-page-1.png \
	$(PREVIEW_DIR)/single-column-cv-de-page-2.png

.PHONY: all pdfs previews verify clean check-tools FORCE

all: pdfs previews verify

pdfs: check-tools $(PDFS)

previews: pdfs $(PREVIEWS)

check-tools:
	@command -v $(LATEXMK) >/dev/null || { echo "Missing latexmk. Install MacTeX first."; exit 1; }
	@command -v xelatex >/dev/null || { echo "Missing xelatex. Install MacTeX first."; exit 1; }

$(DUAL_EN_PDF): FORCE dual-column-cv/english/cv.tex dual-column-cv/english/sections/*.tex dual-column-cv/shared/yaac-another-awesome-cv.cls
	@mkdir -p $(BUILD_DIR)/dual-en $(DIST_DIR)
	cd dual-column-cv/english && TEXINPUTS="../shared//:" $(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error -file-line-error -outdir=../../$(BUILD_DIR)/dual-en cv.tex
	cp $(BUILD_DIR)/dual-en/cv.pdf $@

$(DUAL_DE_PDF): FORCE dual-column-cv/german/cv.tex dual-column-cv/german/sections/*.tex dual-column-cv/shared/yaac-another-awesome-cv.cls
	@mkdir -p $(BUILD_DIR)/dual-de $(DIST_DIR)
	cd dual-column-cv/german && TEXINPUTS="../shared//:" $(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error -file-line-error -outdir=../../$(BUILD_DIR)/dual-de cv.tex
	cp $(BUILD_DIR)/dual-de/cv.pdf $@

$(SINGLE_EN_PDF): FORCE single-column-cv/english/cv.tex single-column-cv/shared/sb2nov-cv.sty dual-column-cv/english/sections/*.tex
	@mkdir -p $(BUILD_DIR)/single-en $(DIST_DIR)
	cd single-column-cv/english && TEXINPUTS="../shared//:" $(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error -file-line-error -outdir=../../$(BUILD_DIR)/single-en cv.tex
	cp $(BUILD_DIR)/single-en/cv.pdf $@

$(SINGLE_DE_PDF): FORCE single-column-cv/german/cv.tex single-column-cv/shared/sb2nov-cv.sty dual-column-cv/german/sections/*.tex
	@mkdir -p $(BUILD_DIR)/single-de $(DIST_DIR)
	cd single-column-cv/german && TEXINPUTS="../shared//:" $(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error -file-line-error -outdir=../../$(BUILD_DIR)/single-de cv.tex
	cp $(BUILD_DIR)/single-de/cv.pdf $@

define preview_rules
$(PREVIEW_DIR)/$(1)-page-1.png: $(DIST_DIR)/ashish-rana-$(1).pdf
	@mkdir -p $(PREVIEW_DIR)
	$(PDFTOPPM) -png -r 120 -f 1 -l 1 -singlefile $$< $(PREVIEW_DIR)/$(1)-page-1

$(PREVIEW_DIR)/$(1)-page-2.png: $(DIST_DIR)/ashish-rana-$(1).pdf
	@mkdir -p $(PREVIEW_DIR)
	$(PDFTOPPM) -png -r 120 -f 2 -l 2 -singlefile $$< $(PREVIEW_DIR)/$(1)-page-2
endef

$(eval $(call preview_rules,dual-column-cv-en))
$(eval $(call preview_rules,dual-column-cv-de))
$(eval $(call preview_rules,single-column-cv-en))
$(eval $(call preview_rules,single-column-cv-de))

verify: previews
	@command -v $(PDFTOTEXT) >/dev/null || { echo "Missing pdftotext. Install Poppler first."; exit 1; }
	@for file in $(PDFS) $(PREVIEWS); do test -s "$$file" || { echo "Missing or empty artifact: $$file"; exit 1; }; done
	@! rg -n "LaTeX Error|Undefined control sequence|Emergency stop|Fatal error|Missing character" $(BUILD_DIR) --glob '*.log'
	@mkdir -p $(BUILD_DIR)/text
	@for pdf in $(PDFS); do $(PDFTOTEXT) "$$pdf" "$(BUILD_DIR)/text/$${pdf:t:r}.txt"; done
	@for text in $(BUILD_DIR)/text/*.txt; do \
		rg -q "Ashish" "$$text" && \
		rg -q "NEC Laboratories Europe" "$$text" && \
		rg -q "Oblivion" "$$text" && \
		rg -q "American Express" "$$text" || { echo "Required active content missing from $$text"; exit 1; }; \
	done
	@! rg -n "Streaming Web Data Integration|Exploring Numerical Calculations with CalcNet|Study Year Gap|Studienlücke" $(BUILD_DIR)/text
	@echo "Verified four PDFs, eight previews, logs, active markers, and disabled-content exclusions."

clean:
	rm -rf $(BUILD_DIR)

FORCE:
