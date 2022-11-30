.PHONY: all clean cleanall cleanext

# -shell-escape not needed for basic usage of imakeidx but is for externalizing
all:
	latexmk -pdf -synctex=1 main

clean: cleanext
	latexmk -c

cleanall: cleanext
	latexmk -C

cleanext:
	rm -f extern/*
	# don't know why these aren't handled even though they're in .latexmkrc
	rm *.glstex
	rm *.bbl
