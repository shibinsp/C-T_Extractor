# T&C Extractor

> [!TIP]
> T&C Extractor is a Python package and command-line utility for extracting Terms & Conditions and legal document content from various file formats, converting them to Markdown for LLM analysis and text pipelines.

> [!IMPORTANT]
> T&C Extractor performs I/O with the privileges of the current process. Sanitize your inputs in untrusted environments, and call the narrowest `convert_*` function needed for your use case (e.g., `convert_stream()`, or `convert_local()`).

## Installation

From PyPI:

```bash
pip install markitdown[all]
```

From source:

```bash
git clone <repo-url>
cd markitdown
pip install -e packages/markitdown[all]
```

## Usage

### Command-Line

```bash
markitdown path-to-file.pdf > extracted.md
```

### Python API

```python
from markitdown import MarkItDown

md = MarkItDown()
result = md.convert("terms-and-conditions.pdf")
print(result.text_content)
```

### More Information

For full documentation, see the project [README.md](../../README.md).
