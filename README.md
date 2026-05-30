# T&C Extractor

A lightweight Python utility for extracting Terms & Conditions and other legal/structured content from various document formats and converting them to clean Markdown — ideal for LLM analysis, compliance pipelines, and text processing workflows.

> [!IMPORTANT]
> T&C Extractor performs I/O with the privileges of the current process. Sanitize your inputs in untrusted environments, and call the narrowest `convert_*` function needed for your use case (e.g., `convert_stream()`, or `convert_local()`). See the [Security Considerations](#security-considerations) section for more information.

## Supported Formats

- PDF
- PowerPoint (PPTX)
- Word (DOCX)
- Excel (XLSX / XLS)
- Images (EXIF metadata and OCR)
- Audio (EXIF metadata and speech transcription)
- HTML
- Text-based formats (CSV, JSON, XML)
- ZIP files (iterates over contents)
- YouTube URLs
- EPubs
- and more

## Prerequisites

Python 3.10 or higher. A virtual environment is recommended:

```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
```

## Installation

```bash
pip install 'markitdown[all]'
```

From source:

```bash
git clone <repo-url>
cd markitdown
pip install -e 'packages/markitdown[all]'
```

## Usage

### Command-Line

```bash
markitdown path-to-file.pdf > extracted.md
```

Use `-o` to write to a file directly:

```bash
markitdown path-to-file.pdf -o extracted.md
```

Pipe content:

```bash
cat path-to-file.pdf | markitdown
```

### Python API

```python
from markitdown import MarkItDown

md = MarkItDown()
result = md.convert("terms-and-conditions.pdf")
print(result.text_content)
```

### LLM-Assisted Extraction (Images & Scanned Docs)

For image-heavy or scanned documents, provide an LLM client for vision-based extraction:

```python
from markitdown import MarkItDown
from openai import OpenAI

md = MarkItDown(
    llm_client=OpenAI(),
    llm_model="gpt-4o",
    llm_prompt="Extract all text and preserve structure.",
)
result = md.convert("scanned-contract.pdf")
print(result.text_content)
```

### Docker

```bash
docker build -t tc-extractor:latest .
docker run --rm -i tc-extractor:latest < your-file.pdf > output.md
```

## Optional Dependencies

Install only what you need:

```bash
pip install 'markitdown[pdf,docx,pptx]'
```

| Flag | Format |
|---|---|
| `[all]` | All optional dependencies |
| `[pptx]` | PowerPoint |
| `[docx]` | Word |
| `[xlsx]` | Excel |
| `[xls]` | Legacy Excel |
| `[pdf]` | PDF |
| `[outlook]` | Outlook messages |
| `[audio-transcription]` | WAV / MP3 transcription |
| `[youtube-transcription]` | YouTube transcripts |
| `[az-doc-intel]` | Azure Document Intelligence |
| `[az-content-understanding]` | Azure Content Understanding |

## Plugins

Plugins are disabled by default. To list installed plugins:

```bash
markitdown --list-plugins
```

To enable plugins:

```bash
markitdown --use-plugins path-to-file.pdf
```

### OCR Plugin

The `markitdown-ocr` plugin adds LLM Vision OCR support for images embedded in PDF, DOCX, PPTX, and XLSX files — useful for scanned T&C documents:

```bash
pip install markitdown-ocr
```

```python
from markitdown import MarkItDown
from openai import OpenAI

md = MarkItDown(
    enable_plugins=True,
    llm_client=OpenAI(),
    llm_model="gpt-4o",
)
result = md.convert("scanned-terms.pdf")
print(result.text_content)
```

See [`packages/markitdown-ocr/README.md`](packages/markitdown-ocr/README.md) for full documentation.

## Azure Document Intelligence

For higher-fidelity extraction of complex PDFs:

```bash
markitdown path-to-file.pdf -o output.md -d -e "<document_intelligence_endpoint>"
```

```python
from markitdown import MarkItDown

md = MarkItDown(docintel_endpoint="<document_intelligence_endpoint>")
result = md.convert("contract.pdf")
print(result.text_content)
```

## Security Considerations

T&C Extractor performs I/O with the privileges of the current process — similar to `open()` or `requests.get()`.

**Sanitize inputs:** Do not pass untrusted input directly. Validate and restrict file paths, URI schemes, and network destinations in hosted environments.

**Use the narrowest API:** Prefer `convert_stream()` > `convert_local()` > `convert_response()` > `convert_uri()` depending on your use case.

## Contributing

Contributions are welcome. Please open issues or pull requests in the repository.

### Running Tests

```bash
cd packages/markitdown
pip install hatch
hatch test
```

### Writing Plugins

See [`packages/markitdown-sample-plugin`](packages/markitdown-sample-plugin) for a plugin template.

## License

MIT — see [LICENSE](LICENSE).
