.DEFAULT_GOAL := build

# Downloads and vendors dependencies
modules:
	go mod tidy
	go mod vendor

# Formats all go source code
format:
	grep -L -R "Code generated .* DO NOT EDIT" --exclude-dir=.git --exclude-dir=vendor --include="*.go" | \
	xargs -n 1 gofumports -w -local github.com/davidsbond/homelab

# Runs go tests
test:
	go test -race ./...

# Installs go tooling
install-tools:
	go install \
		github.com/golangci/golangci-lint/cmd/golangci-lint \
		mvdan.cc/gofumpt/gofumports \
		github.com/sebdah/markdown-toc

# Installs the latest UPX binary to GOBIN.
install-upx:
	./scripts/install_upx.sh

# Lints go source code
lint:
	golangci-lint run --enable-all

# Generates go source code
generate:
	markdown-toc --no-header --skip-headers=1 --replace --inline README.md
	go generate -x ./...

# Checks for any changes, including new files
has-changes:
	git add .
	git diff --staged --exit-code

# Compiles go source code
build:
	./scripts/build.sh

# Creates docker image for various architectures.
docker:
	./scripts/docker.sh

# Compresses binaries
pack:
	upx `find ./bin -type f`
