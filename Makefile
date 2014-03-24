.PHONY: build clean test

BINARY = content-store

build:
	go build -o $(BINARY)

clean:
	-rm $(BINARY)

test:
	go test
