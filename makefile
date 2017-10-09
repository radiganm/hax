#!/usr/bin/make -f
## makefile (for hax)
## Copyright 2017 Mac Radigan
## All Rights Reserved

.PHONY: build clean run install test help
.DEFAULT_GOAL := build

target = hax

demo = ./demo/demo-0

default: build

build:
	stack $@

install:
	stack $@

clean:
	stack $@

run:
	~/.local/bin/$(target)-exe

test:
	~/.local/bin/$(target)-exe          \
	  --include  $(demo)/include        \
	  --template $(demo)/template       \
	  --generate $(demo)/pi.hs

help:
	~/.local/bin/$(target)-exe --help

## *EOF*
