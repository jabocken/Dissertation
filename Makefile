PAPER = main
BIB = references
TEX = $(wildcard *.tex)

.PHONY: all clean

mk:
	latexmk -xelatex -shell-escape $(PAPER)

clean:
	rm -f *.aux *.bbl *.blg *.log *.lof *.lot *.nlo *.nls *.fls *.out *.fdb_latexmk *.toc *.xdv $(PAPER).pdf extern/*
