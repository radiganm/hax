#!/usr/bin/make -f
## makefile (for stack)
## Copyright 2017 Mac Radigan
## All Rights Reserved

.PHONY: build clean run install
.DEFAULT_GOAL := build

target = hax

default: build

build:
	stack $@

install:
	stack $@

clean:
	stack $@

run:
	~/.local/bin/$(target)-exe

## *EOF*
