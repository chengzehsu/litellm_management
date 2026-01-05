# Use Python 3.11 slim image for smaller size
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies if needed
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN useradd -m -u 1000 litellm && \
    chown -R litellm:litellm /app

# Copy requirements first for better caching
COPY --chown=litellm:litellm requirements.txt .

# Install Python dependencies as root (needed for system packages)
RUN pip install --no-cache-dir -r requirements.txt

# Copy configuration files
COPY --chown=litellm:litellm config.yaml .
COPY --chown=litellm:litellm start.sh .

# Make start script executable
RUN chmod +x start.sh

# Switch to non-root user
USER litellm

# Expose default LiteLLM proxy port
EXPOSE 4000

# Health check - LiteLLM proxy exposes /healthz endpoint
# If it doesn't exist, we check if the service is responding
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:4000/healthz || \
       curl -f http://localhost:4000/v1/models || exit 1

# Start LiteLLM proxy
CMD ["./start.sh"]
