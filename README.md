> [!WARNING]
> This software requires a valid Highcharts license for commercial use. If you do not have a license, one can be obtained here: https://shop.highsoft.com

# highcharts-export-server

A Dockerized [Highcharts Export Server](https://github.com/highcharts/node-export-server) that renders Highcharts charts to images (PNG, SVG, PDF) via an HTTP API. Built on Node.js with Google Chrome (via Puppeteer) for rasterization.

## Requirements

- Docker
- Docker Compose
- A valid [Highcharts license](https://shop.highsoft.com) for commercial use

## Usage

### Production

Pull and start the server using the published image:

```bash
docker compose up -d
```

The server will be available at `http://localhost:8080`.

### Development

Build and start the server locally:

```bash
docker compose -f docker-compose.dev.yml up -d
```

## Health Check

```bash
curl http://localhost:8080/health
```

## Configuration

| File | Purpose |
|---|---|
| `config.json` | Export server runtime options (e.g. Puppeteer args) |
| `chart-config.json` | Default chart configuration used during the image build warm-up |

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `EXPORT_RASTERIZATION_TIMEOUT` | `20000` | Timeout (ms) for chart rasterization |
| `SERVER_PORT` | `8080` | HTTP port the server listens on |
| `LOGGING_LEVEL` | `2` (prod) | Log verbosity level |

## Docker Image

The production image is published at:

```
ghcr.io/reflective-technology/highcharts-export-server:latest
```

> **Note:** Because Chrome does not support ARM on Linux, the image is pinned to `linux/amd64`. On Apple Silicon Macs, Docker Desktop will emulate x86_64 automatically.

## License

See [LICENSE](LICENSE).
