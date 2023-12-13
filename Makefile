.PHONY: help
.ONESHELL:
PACKAGE := template
VERSION := $(shell grep -e '^__version__\s*=\s*".*"'  'src/ptolemy/__init__.py' | sed 's%^__version__\s*=\s*"\(.*\)"%\1%g')
CONTAINER_REGISTRY := ghcr.io
CONTAINER_REPO := project-defiant
IMAGE := $(CONTAINER_REGISTRY)/$(CONTAINER_REPO)/$(PACKAGE):$(VERSION)
default: help

version: ## Display current version of the package
	@printf "template version: %s\n" $(VERSION)

install: ## Install package within isolated environement locally with hatch
	@hatch env create

test-full: ## Run tests with coverage report with pytest
	@hatch run cov

test: ## Run tests with pytest
	@hatch run test

fmt: ## Format with ruff and black
	@hatch run fmt

lint: ## Lint code styling with ruff and black
	@hatch run style

typing: ## Check type annotations with mypy
	@hatch run typing

clean: ## Clean the environment
	@hatch env prune

distribute: install ## Create a distribution package
	@hatch build

docker-build: distribute  ## Create docker image with image
	@docker build --build-arg VERSION=$(VERSION) . -t $(IMAGE) -f docker/Dockerfile

docker-push: docker-build ## Push image to registry
	@docker push $(IMAGE)

all: install fmt test lint typing ## Run all utilities before commit

release: ## Release pkg
	git pull
	git tag -a $(VERSION) -m "version $(VERSION)"
	git tag --delete latest
	git tag -a latest -m "latest version"
	git push --delete origin latest
	git push --tags


help: # Show help for each of the Makefile recipes.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
