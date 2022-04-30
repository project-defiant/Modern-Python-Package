# setup environment
VERSION:=1.0.0
PACKAGE:="ModernPythonPackage"
VIRTUAL_ENV:=".venv"

.ONESHELL:
# command for installing package in editable mode
install:
	python -m venv $(VIRTUAL_ENV)
	. .$(VIRTUAL_ENV)/bin/activate
	python -m pip install --upgrade pip
	python -m pip install --upgrade setuptools wheel 
	python -m pip install -e .[dev]

# command for cleaning the build directory
clean:
	rm -rf $(VIRTUAL_ENV)
	rm -rf build
	rm -rf docker/dist
	rm -rf *.egg-info

# typecheck with mypy
typecheck:
	. .$(VIRTUAL_ENV)/bin/activate
	mypy

# format with black
prettify:
	. .$(VIRTUAL_ENV)/bin/activate
	black $(PACKAGE) .

# lint with flake8
lint:
	. .$(VIRTUAL_ENV)/bin/activate
	flake8 $(PACKAGE)

# test with pytest
test:
	. .$(VIRTUAL_ENV)/bin/activate
	pytest -vv

# test only last failed tests
test-failed:
	. .$(VIRTUAL_ENV)/bin/activate
	pytest -vv --lf

# create a distribution package
distribute: prettify typecheck lint test clean install 
	. .$(VIRTUAL_ENV)/bin/activate
	python -m pip install --upgrade build
	python -m build --outdir docker/dist
	sed -i '/ARG VERSION=/c\ARG VERSION=$(VERSION)' Docker/Dockerfile

# build the docker image
build: distribute
	. .$(VIRTUAL_ENV)/bin/activate
	docker build -t $PACKAGE:$(VERSION) docker/.
