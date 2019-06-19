all: checks
	GO111MODULE=on go install -v ./...

checks:
	bash checks.sh

staticcheck:
	go get -d ./...
	go get honnef.co/go/tools/...
	staticcheck ./...

update-modules:
	rm -f go.mod go.sum
	GO111MODULE=on go get -u -d ./...
	GO111MODULE=on go mod tidy

dist:
	rm -rf build
	mkdir -p build
	docker pull golang:latest
	docker run --rm -it \
		-e GO111MODULE=on \
		-e GOBIN=/tmp/bin \
		-e GOCACHE=/tmp/.cache \
		-u $$(id -u):$$(id -g) \
		-v ${PWD}/build:/tmp/bin \
		-w /go/src/github.com/tinyci/ci-runners \
		-v ${PWD}:/go/src/github.com/tinyci/ci-runners \
		golang:latest \
		go install -v ./...
	tar cvzf release.tar.gz build/*
