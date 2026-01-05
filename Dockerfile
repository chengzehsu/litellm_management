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

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy configuration files
COPY config.yaml .
COPY start.sh .

# Make start script executable
RUN chmod +x start.sh

# Expose default LiteLLM proxy port
EXPOSE 4000

# Health check (using curl if available, otherwise skip)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:4000/health || exit 1

# Start LiteLLM proxy
CMD ["./start.sh"]

