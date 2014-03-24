.PHONY: build run clean test

BINARY = content-store

build:
	go build -o $(BINARY)

run:
	go run main.go

clean:
	-rm $(BINARY)

test: build
	go test
	bundle install $(BUNDLER_ARGS) --quiet
	USE_COMPILED_APPLICATION=1 bundle exec rspec
