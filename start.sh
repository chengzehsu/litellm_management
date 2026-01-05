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
MISSING_VARS=()

if [ -z "$LITELLM_MASTER_KEY" ]; then
    MISSING_VARS+=("LITELLM_MASTER_KEY")
fi

if [ -z "$DATABASE_URL" ]; then
    MISSING_VARS+=("DATABASE_URL")
fi

if [ -z "$LANGFUSE_PUBLIC_KEY" ] || [ -z "$LANGFUSE_SECRET_KEY" ]; then
    echo "Warning: Langfuse keys are not set. Langfuse integration may not work."
fi

# Exit if critical variables are missing
if [ ${#MISSING_VARS[@]} -gt 0 ]; then
    echo "Error: Missing required environment variables:"
    printf '  - %s\n' "${MISSING_VARS[@]}"
    echo ""
    echo "Please set these variables before starting the proxy."
    exit 1
fi

# Start LiteLLM proxy
exec litellm --config config.yaml --port ${PORT:-4000} --host ${HOST:-0.0.0.0}
