# Docker Deployment

## Quick Start (Recommended: use pre-built image)

```bash
# 1. Create .env from template
cp .env.example .env

# 2. Edit .env as needed (model, port, etc.)
vim .env

# 3. Pull and start
docker compose up -d
```

`docker-compose.yml` directly references `ghcr.io/henryxrl/deepseek-cursor-proxy-turbo:latest`, no local build required.

## Local Development Build

If you're building from source, use the dev Compose file:

```bash
docker compose -f docker-compose.dev.yml up -d --build
```

`docker-compose.dev.yml` builds the image from the current directory with `build: .`.

After startup, set the API Base URL in Cursor to `http://localhost:9000/v1`.

## Environment Variable Reference

| Variable | Corresponding Parameter | Default |
| --- | --- | --- |
| `PROXY_HOST` | `--host` | `0.0.0.0` |
| `PROXY_PORT` | `--port` | `9000` |
| `PROXY_MODEL` | `--model` | `deepseek-v4-pro` |
| `PROXY_BASE_URL` | `--base-url` | `https://api.deepseek.com` |
| `PROXY_THINKING` | `--thinking` | `enabled` |
| `PROXY_REASONING_EFFORT` | `--reasoning-effort` | `max` |
| `PROXY_NGROK` | `--ngrok` / `--no-ngrok` | `0` |
| `PROXY_NGROK_URL` | `--ngrok-url` | — |
| `PROXY_VERBOSE` | `--verbose` / `--no-verbose` | `0` |
| `PROXY_DISPLAY_REASONING` | `--display-reasoning` / `--no-display-reasoning` | `1` |
| `PROXY_COLLAPSIBLE_REASONING` | `--collapsible-reasoning` / `--no-collapsible-reasoning` | `1` |
| `PROXY_CORS` | `--cors` / `--no-cors` | `0` |
| `PROXY_REQUEST_TIMEOUT` | `--request-timeout` | `300` |
| `PROXY_MAX_REQUEST_BODY_BYTES` | `--max-request-body-bytes` | `20971520` |
| `PROXY_REASONING_CONTENT_PATH` | `--reasoning-content-path` | `/data/reasoning_content.sqlite3` |
| `PROXY_REASONING_CACHE_MAX_AGE_SECONDS` | `--reasoning-cache-max-age-seconds` | `2592000` |
| `PROXY_REASONING_CACHE_MAX_ROWS` | `--reasoning-cache-max-rows` | `100000` |
| `PROXY_MISSING_REASONING_STRATEGY` | `--missing-reasoning-strategy` | `recover` |
| `PROXY_USER_MESSAGE_SUFFIX` | `--user-suffix` | — |
| `PROXY_TRACE_DIR` | `--trace-dir` | — |
| `PROXY_CONFIG` | `--config` | `/data/config.yaml` |

Boolean variables support `1`/`0`, `true`/`false`, `yes`/`no`, `on`/`off` (case-insensitive). Unset variables are not passed as arguments, so the program uses its own defaults.

## Plain Docker (without Compose)

```bash
docker run -d \
  --name deepseek-cursor-proxy-turbo \
  -p 9000:9000 \
  -v proxy-data:/data \
  --restart unless-stopped \
  ghcr.io/henryxrl/deepseek-cursor-proxy-turbo:latest
```

Override defaults with `-e`:

```bash
docker run -d \
  --name deepseek-cursor-proxy-turbo \
  -p 9000:9000 \
  -v proxy-data:/data \
  -e PROXY_MODEL=deepseek-chat \
  -e PROXY_THINKING=disabled \
  -e PROXY_VERBOSE=1 \
  ghcr.io/henryxrl/deepseek-cursor-proxy-turbo:latest
```
