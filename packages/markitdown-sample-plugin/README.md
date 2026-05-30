# T&C Extractor Sample Plugin

A template for building custom converter plugins for T&C Extractor.

## How Plugins Work

Plugins register custom `DocumentConverter` implementations that T&C Extractor discovers automatically via Python entry points when `enable_plugins=True` is set.

## Building a Plugin

### 1. Implement a DocumentConverter

```python
from typing import BinaryIO, Any
from markitdown import MarkItDown, DocumentConverter, DocumentConverterResult, StreamInfo

class MyConverter(DocumentConverter):

    def __init__(
        self, priority: float = DocumentConverter.PRIORITY_SPECIFIC_FILE_FORMAT
    ):
        super().__init__(priority=priority)

    def accepts(
        self,
        file_stream: BinaryIO,
        stream_info: StreamInfo,
        **kwargs: Any,
    ) -> bool:
        # Return True if this converter can handle the given file
        return stream_info.extension in [".myext"]

    def convert(
        self,
        file_stream: BinaryIO,
        stream_info: StreamInfo,
        **kwargs: Any,
    ) -> DocumentConverterResult:
        # Read the stream and return Markdown content
        content = file_stream.read().decode("utf-8")
        return DocumentConverterResult(markdown=content)
```

### 2. Export the Plugin Interface

```python
# Required: plugin interface version (only version 1 is supported)
__plugin_interface_version__ = 1

def register_converters(markitdown: MarkItDown, **kwargs):
    """Called each time a MarkItDown instance is created."""
    markitdown.register_converter(MyConverter())
```

### 3. Register the Entry Point in pyproject.toml

```toml
[project.entry-points."markitdown.plugin"]
my_plugin = "my_package_name"
```

## Installation

```bash
pip install -e .
```

Verify the plugin is discovered:

```bash
markitdown --list-plugins
```

## Usage

Command-line:

```bash
markitdown --use-plugins path-to-file.myext
```

Python:

```python
from markitdown import MarkItDown

md = MarkItDown(enable_plugins=True)
result = md.convert("path-to-file.myext")
print(result.text_content)
```

## License

MIT — see [LICENSE](../markitdown/LICENSE).
