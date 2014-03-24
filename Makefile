.PHONY: build run clean test

BINARY = content-store

build:
	go build -o $(BINARY)

run:
	go run main.go

clean:
	-rm $(BINARY)

test:
	go test
