.PHONY: help install test lint format typecheck clean

PKG := packages/markitdown

help:
	@echo "Available targets:"
	@echo "  install    Install markitdown with all extras in editable mode"
	@echo "  test       Run the test suite (hatch)"
	@echo "  lint       Run ruff lint checks"
	@echo "  format     Format code with black"
	@echo "  typecheck  Run mypy type checks"
	@echo "  clean      Remove build artifacts and caches"

install:
	pip install -e "$(PKG)[all]"

test:
	cd $(PKG) && hatch test

lint:
	ruff check $(PKG)/src

format:
	black $(PKG)/src $(PKG)/tests

typecheck:
	cd $(PKG) && hatch run types:check

clean:
	rm -rf build dist *.egg-info .pytest_cache .mypy_cache .ruff_cache
	find . -type d -name __pycache__ -exec rm -rf {} +
