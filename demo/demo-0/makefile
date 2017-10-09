#!/usr/bin/make -sf
## makefile
##
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: hello clean
.DEFAULT_GOAL := all

all: hello

root = ../..
out = $(root)/demo-out/demo-1

clean:
	rm -Rf $(out)

hello:
	env PYTHONPATH=$(root)/library       \
	  python3 $(root)/dox.py             \
	    -v                               \
	    -e                               \
	    -g ./$@/generator/pi.py          \
	    -I ./$@/include                  \
	    -t ./$@/template                 \
	    -o $(out)/$@

## *EOF*
