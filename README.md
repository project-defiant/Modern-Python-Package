# Modern-python-package

This repo is created as a template for modern python packaging setup

Some of the tools used by this template
- [x] hatch as a package manager
- [x] ruff
- [x] pytest
- [x] black
- [x] towncrier
- [x] mypy
- [x] pre-commit
- [x] coverage
- [x] click

To use this template 
* remove this readme
* change `template` from package name
```
mv src/template src/{your package name}
sed -i 's/template/{your package name}/g' pyproject.toml Makefile docker/Dockerfile
```
* install package
```
make install
```
