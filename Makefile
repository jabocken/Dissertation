.PHONY: all clean cleanall cleanext

# -shell-escape not needed for basic usage of imakeidx
all:
	latexmk -pdf main

clean: cleanext
	latexmk -c

cleanall: cleanext
	latexmk -C

cleanext:
	rm -f extern/*
