.PHONY: all vendor image clean

all:
	mkdir -p ./bin
	CGO_ENABLED=0 GOOS=linux go build -o ./bin/kube-version

image:
	./build/build-image.sh

vendor:
	glide update --delete --update-vendored --strip-vcs --strip-vendor

clean:
	rm -fr ./bin
