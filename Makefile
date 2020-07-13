.PHONY: dev build install image test release clean

CGO_ENABLED=0
VERSION=$(shell git describe --abbrev=0 --tags)
COMMIT=$(shell git rev-parse --short HEAD)

all: dev

dev: build
	@./rss2twtxt -v
	@./rss2twtxt -s

build: clean
	@go build \
		-tags "netgo static_build" -installsuffix netgo \
		-ldflags "-w -X $(shell go list).Version=$(VERSION) -X $(shell go list).Commit=$(COMMIT)" \
		.

install: build
	@go install

image:
	@docker build -t prologic/rss2twtxt .

test: install
	@go test

release:
	@./tools/release.sh

clean:
	@git clean -f -d -X
