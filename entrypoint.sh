#!/bin/sh
exec deno run --unstable-broadcast-channel --allow-env --allow-read=/app/data --allow-write=/app/data --allow-net=:$PORT "$SCRIPT_URL"
