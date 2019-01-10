
LATEX=pdflatex

BIBTEX=bibtex
PAPER=wormspace
BIBFILE=$(PAPER)
TEXFILES = $(wildcard *.tex)

all: $(PAPER).pdf

fresh: clean all

$(PAPER).pdf: $(TEXFILES) $(BIBFILE).bib
	$(LATEX) $(PAPER)
	$(BIBTEX) $(PAPER)
	$(LATEX) $(PAPER)
	$(LATEX) $(PAPER)
	$(LATEX) $(PAPER)

clean:
	rm -f *.aux *.log *~ .DS_Store *.dvi $(PAPER).ps $(PAPER).pdf \
		*.lot *.lof *.toc *.blg *.bbl *.ent *.bak *.out
