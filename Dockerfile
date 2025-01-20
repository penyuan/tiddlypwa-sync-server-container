FROM denoland/deno:latest

WORKDIR /app

# Create a directory for the database
RUN mkdir -p /app/data

# The script to run
ENV SCRIPT_URL=https://codeberg.org/valpackett/tiddlypwa/raw/branch/release/server/run.ts

# Default environment variables
ENV PORT=8000
ENV DB_PATH=/app/data/pwa.db

# Expose the configured port
EXPOSE ${PORT}

# Add and make the entrypoint script executable
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]
