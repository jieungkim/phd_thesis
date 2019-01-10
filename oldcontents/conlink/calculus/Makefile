.PHONY: all clean distclean

all: calculus.pdf 

clean:
	rm -f *~ *.pdf *.aux *.log *.dvi *.ps *.bbl *.blg *.out *.vtc

distclean: clean
	rm -f *.tfm *.*pk
	tar tzf mbboard.tar.gz | xargs rm -f

%.pdf: %.tex *.tex refs.bib 
	pdflatex $< && (bibtex $(basename $<) || true) && pdflatex $< && pdflatex $<  # NO LONGER works with PSTricks
#	latex $< && (bibtex $(basename $<) || true) && latex $< && latex $< && dvips -o $(basename $<).ps $(basename $<).dvi && ps2pdf $(basename $<).ps
