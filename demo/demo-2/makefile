#!/usr/bin/make -sf
## makefile
##
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: simulation analysis report clean
.DEFAULT_GOAL := pandoc

all: pandoc

root = ../..
out = $(root)/demo-out/demo-2

clean:
	rm -Rf $(out)

simulation:
	env PYTHONPATH=$(root)/library       \
	  python3 $(root)/dox.py             \
	    -v                               \
	    -e                               \
	    -f                               \
	    -g ./$@/generator/pi.py          \
	    -I ./$@/include                  \
	    -t ./$@/template                 \
	    -o $(out)/$@

analysis: simulation
	env PYTHONPATH=$(root)/library       \
	  python3 $(root)/dox.py             \
	    -v                               \
	    -e                               \
	    -f                               \
	    -g ./$@/generator/pi.py          \
	    -I ./$@/include                  \
	    -t ./$@/template                 \
	    -o $(out)/$@

report: analysis
	#env PYTHONPATH=$(root)/library              \
	#  python3 $(root)/virtualize.py             \
	#    -v                                      \
	#    -f $(out)/analysis                      \
	#    -o $(out)/$@
	env PYTHONPATH=$(root)/library              \
	  python3 $(root)/dox.py                    \
	    -v                                      \
	    -e                                      \
	    -f                                      \
	    -g ./$@/generator/pi.py                 \
	    -I ./$@/include:$(out)/analysis/include \
	    -t ./$@/template                        \
	    -o $(out)/$@

pandoc: report
	(cd $(out)/report;              \
	  pandoc Report.md              \
	     --wrap=preserve            \
	     -f markdown                \
	     -t latex                   \
	     -o Report.pdf)

## *EOF*
