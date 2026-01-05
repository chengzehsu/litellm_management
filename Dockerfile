# Use official LiteLLM Docker image with all dependencies included
FROM ghcr.io/berriai/litellm-database:main-latest

# Set working directory
WORKDIR /app

# Copy configuration file
COPY config.yaml /app/config.yaml

# Expose LiteLLM proxy port (Zeabur uses PORT env var, default to 8080)
EXPOSE 8080

# Start LiteLLM proxy with config
# Note: The base image already has litellm as ENTRYPOINT, so we only provide arguments
CMD ["--config", "/app/config.yaml", "--port", "8080", "--host", "0.0.0.0"]
