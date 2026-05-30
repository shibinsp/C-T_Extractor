# Contributing

Thanks for your interest in contributing! This guide covers the basics for
getting set up and submitting changes.

## Development Setup

```bash
# Install the package with all optional dependencies in editable mode
make install
# or:
pip install -e "packages/markitdown[all]"
```

## Common Tasks

A `Makefile` is provided for convenience:

| Command          | Description                              |
| ---------------- | ---------------------------------------- |
| `make test`      | Run the test suite (`hatch test`)        |
| `make lint`      | Run `ruff` lint checks                   |
| `make format`    | Format code with `black`                 |
| `make typecheck` | Run `mypy` type checks                   |
| `make clean`     | Remove build artifacts and caches        |

> **Note:** Audio transcription tests require `ffmpeg` to be installed and on
> your `PATH`.

## Submitting Changes

1. Fork the repo and create a feature branch off `main`.
2. Make your change, adding or updating tests where appropriate.
3. Ensure `make test`, `make lint`, and `make format` all pass.
4. Open a pull request describing the change and the motivation behind it.

## Reporting Security Issues

Please do **not** open public issues for security vulnerabilities. See
[SECURITY.md](SECURITY.md) for how to report them privately.
