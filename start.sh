#!/bin/bash

# Start LiteLLM Proxy with config.yaml
# This script is used to start the LiteLLM proxy server

set -e

echo "Starting LiteLLM Proxy..."

# Check if config.yaml exists
if [ ! -f "config.yaml" ]; then
    echo "Error: config.yaml not found!"
    exit 1
fi

# Check required environment variables
if [ -z "$LITELLM_MASTER_KEY" ]; then
    echo "Warning: LITELLM_MASTER_KEY is not set"
fi

if [ -z "$DATABASE_URL" ]; then
    echo "Warning: DATABASE_URL is not set"
fi

if [ -z "$LANGFUSE_PUBLIC_KEY" ] || [ -z "$LANGFUSE_SECRET_KEY" ]; then
    echo "Warning: Langfuse keys are not set. Langfuse integration may not work."
fi

# Start LiteLLM proxy
exec litellm --config config.yaml --port ${PORT:-4000} --host ${HOST:-0.0.0.0}

