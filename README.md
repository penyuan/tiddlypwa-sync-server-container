# TiddlyPWA sync server container

This repository contains a `Dockerfile` for creating a container image for running the [TiddlyPWA sync server](https://codeberg.org/valpackett/tiddlypwa). It uses the official Deno runtime and provides a simple way to run the sync server with environment variable configuration.

This repository is forked from the original: https://github.com/tanc/tiddypwa-sync-server-docker

## Quick Start

1. Generate your admin password hash and salt using Podman (or Docker) (no local Deno installation required):

   ```bash
   podman run --rm denoland/deno:latest run https://codeberg.org/valpackett/tiddlypwa/raw/branch/release/server/hash-admin-password.ts
   ```

2. Run the container with the required environment variables:
   ```bash
   podman run -d \
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

~~- `PORT`: Server port (default: 8000)~~ (TiddlyPWA seems to be hardcoded to listen on port 8000, see [here](https://codeberg.org/valpackett/tiddlypwa/src/branch/trunk/server/run.ts))
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
podman build -t tiddlypwa-sync-server .
```

## GitHub Actions

This repository includes GitHub Actions workflows to:

1. Build the container image
2. Push to Docker Hub on new tags and main branch updates

To use the GitHub Actions:

1. Fork this repository
2. Add your Docker Hub credentials as secrets:
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`
3. Push a tag (e.g., `v1.0.0`) to trigger a release build