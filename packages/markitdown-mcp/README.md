# T&C Extractor MCP

> [!IMPORTANT]
> The T&C Extractor MCP server is meant for **local use** with local trusted agents. When running in Streamable HTTP or SSE mode, it binds to `localhost` by default. DO NOT bind to other interfaces unless you understand the [security implications](#security-considerations).

An MCP server that exposes T&C Extractor as a tool for AI agents. It provides one tool — `convert_to_markdown(uri)` — which accepts any `http:`, `https:`, `file:`, or `data:` URI and returns Markdown.

## Installation

```bash
pip install markitdown-mcp
```

## Usage

### STDIO (default)

```bash
markitdown-mcp
```

### Streamable HTTP / SSE

```bash
markitdown-mcp --http --host 127.0.0.1 --port 3001
```

## Running in Docker

```bash
docker build -t tc-extractor-mcp:latest .
docker run -it --rm tc-extractor-mcp:latest
```

To mount a local directory:

```bash
docker run -it --rm -v /home/user/data:/workdir tc-extractor-mcp:latest
```

Files under `/home/user/data` will be accessible at `/workdir` inside the container.

## Connecting to Claude Desktop

Edit your `claude_desktop_config.json` to include:

```json
{
  "mcpServers": {
    "tc-extractor": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "tc-extractor-mcp:latest"
      ]
    }
  }
}
```

With a mounted directory:

```json
{
  "mcpServers": {
    "tc-extractor": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-v",
        "/home/user/data:/workdir",
        "tc-extractor-mcp:latest"
      ]
    }
  }
}
```

## Debugging

Use the MCP Inspector:

```bash
npx @modelcontextprotocol/inspector
```

Then connect at `http://localhost:5173/` and:

- **STDIO**: select `STDIO`, enter `markitdown-mcp` as the command, click `Connect`
- **Streamable HTTP**: select `Streamable HTTP`, enter `http://127.0.0.1:3001/mcp`, click `Connect`
- **SSE**: select `SSE`, enter `http://127.0.0.1:3001/sse`, click `Connect`

Navigate to `Tools → List Tools → convert_to_markdown` and run it on any valid URI.

## Security Considerations

The server has no authentication and runs with the privileges of the current user. The `convert_to_markdown` tool can read any file the server user can access. For added security, run in a sandboxed container with restricted file and network permissions. DO NOT bind to non-localhost interfaces without understanding the security implications.
