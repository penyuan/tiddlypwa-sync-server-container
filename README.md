# TiddlyPWA Sync Server Docker

This repository contains a Docker image for running the TiddlyPWA sync server. It uses the official Deno runtime and provides a simple way to run the sync server with environment variable configuration.

## Quick Start

1. Generate your admin password hash and salt using Docker (no local Deno installation required):

   ```bash
   docker run --rm denoland/deno:latest run https://codeberg.org/valpackett/tiddlypwa/raw/branch/release/server/hash-admin-password.ts
   ```

2. Run the container with the required environment variables:
   ```bash
   docker run -d \
     --name tiddlypwa-sync \
     -p 8000:8000 \
     -v $(pwd)/data:/app/data \
     -e ADMIN_PASSWORD_HASH=your_generated_hash \
     -e ADMIN_PASSWORD_SALT=your_generated_salt \
     -e DB_PATH=/app/data/pwa.db \
     tanc/tiddlypwa-sync-server
   ```

## Required Environment Variables

The following environment variables **must** be set for the server to function:

- `ADMIN_PASSWORD_HASH`: Hash of the admin password (generated in step 1)
- `ADMIN_PASSWORD_SALT`: Salt used for the password hash (generated in step 1)
- `DB_PATH`: Path to the SQLite database file (recommended: /app/data/pwa.db)

## Optional Environment Variables

- `PORT`: Server port (default: 8000)
- `HOST`: Server host (default: 0.0.0.0)
- `BASEPATH`: Base path when running behind a reverse proxy

## Running Behind a Reverse Proxy

It's recommended to run this behind a reverse proxy with TLS support. Example Caddy configuration:

```caddy
wiki.example.com {
    reverse_proxy localhost:8000
}
```

## Building Locally

```bash
docker build -t tiddlypwa-sync-server .
```

## GitHub Actions

This repository includes GitHub Actions workflows to:

1. Build the Docker image
2. Push to Docker Hub on new tags and main branch updates

To use the GitHub Actions:

1. Fork this repository
2. Add your Docker Hub credentials as secrets:
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`
3. Push a tag (e.g., `v1.0.0`) to trigger a release build
