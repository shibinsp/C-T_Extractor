# T&C Extractor OCR Plugin

LLM Vision OCR plugin for T&C Extractor that extracts text from images embedded in PDF, DOCX, PPTX, and XLSX files — including full-page OCR for scanned documents.

Uses the same `llm_client` / `llm_model` pattern as T&C Extractor's built-in image descriptions. No new ML libraries or binary dependencies required.

## Features

- **PDF**: Inline OCR for embedded images; full-page fallback for scanned PDFs
- **DOCX**: OCR for images in Word documents
- **PPTX**: OCR for images in PowerPoint presentations
- **XLSX**: OCR for images embedded in Excel spreadsheets
- **Structure-preserving**: Document flow (headings, tables, paragraphs) is maintained around OCR blocks

## Installation

```bash
pip install markitdown-ocr
pip install openai  # or any OpenAI-compatible client
```

## Usage

### Command Line

```bash
markitdown document.pdf --use-plugins --llm-client openai --llm-model gpt-4o
```

### Python API

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

If no `llm_client` is provided the plugin loads but OCR is silently skipped, falling back to the built-in converter.

### Custom Prompt

```python
md = MarkItDown(
    enable_plugins=True,
    llm_client=OpenAI(),
    llm_model="gpt-4o",
    llm_prompt="Extract all text, preserving table structure.",
)
```

### Azure OpenAI

```python
from openai import AzureOpenAI

md = MarkItDown(
    enable_plugins=True,
    llm_client=AzureOpenAI(
        api_key="...",
        azure_endpoint="https://your-resource.openai.azure.com/",
        api_version="2024-02-01",
    ),
    llm_model="gpt-4o",
)
```

## How It Works

1. T&C Extractor discovers the plugin via the `markitdown.plugin` entry point
2. `register_converters()` is called with `llm_client` and `llm_model`
3. An `LLMVisionOCRService` is created from those kwargs
4. Four OCR-enhanced converters register at **priority -1.0** (before built-ins at 0.0)

When a file is converted:
1. The OCR converter extracts embedded images from the document
2. Each image is sent to the LLM with an extraction prompt
3. Returned text is inserted inline, preserving document structure
4. If an LLM call fails, conversion continues without that image's text

## Output Format

Every OCR block is wrapped as:

```
*[Image OCR]
<extracted text>
[End OCR]*
```

## Supported Format Details

| Format | Behaviour |
|---|---|
| **PDF** | Inline image OCR; full-page 300 DPI render for scanned pages; PyMuPDF fallback for malformed PDFs |
| **DOCX** | OCR via `doc.part.rels`; placeholder injection preserves heading/table flow |
| **PPTX** | Picture shapes, placeholder images, and group images; top-to-left reading order per slide |
| **XLSX** | Per-sheet image extraction via `sheet._images`; listed after sheet data table |

## Troubleshooting

**OCR text missing** — verify `llm_client` and `llm_model` are both set.

**Plugin not loading** — run `markitdown --list-plugins` and confirm `ocr` is listed.

**API errors** — the plugin logs warnings and continues. Check your API key, quota, and that the model supports vision.

## Development

```bash
cd packages/markitdown-ocr
pytest tests/ -v
```

Build from source:

```bash
git clone <repo-url>
cd markitdown/packages/markitdown-ocr
pip install -e .
```

## Contributing

Contributions are welcome. See the repository for guidelines.

## License

MIT — see [LICENSE](LICENSE).
