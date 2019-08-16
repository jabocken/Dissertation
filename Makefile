PAPER = main
BIB = references
TEX = $(wildcard *.tex)

.PHONY: all clean

mk:
	latexmk -xelatex -shell-escape $(PAPER)

clean:
	rm -f *.aux *.auxlock *.bbl *.blg *.log *.loa *.lof *.lol *.lot *.nlo \
		*.nls *.fls *.idx *.ind *.ilg *.out \
		*.fdb_latexmk *.toc *.xdv $(PAPER).pdf extern/*
