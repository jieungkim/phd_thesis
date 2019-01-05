all:
	pdflatex thesis.tex
	bibtex thesis
	pdflatex thesis.tex
	pdflatex thesis.tex
Bibtex:
	bibtex thesis

clean:
	rm -f *.aux *.pdf *.ps *.log *.bbl *.blg *.dvi *.lop *.lot *.out *.gz *.lof *.toc
