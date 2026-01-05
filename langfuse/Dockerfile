# Langfuse Self-Hosted Deployment for Zeabur
# This Dockerfile uses the official Langfuse image
# Database connections are configured via environment variables

FROM langfuse/langfuse:latest

# Expose the default Langfuse port
EXPOSE 3000

# The official image already has the correct entrypoint
# Environment variables needed:
# - DATABASE_URL: PostgreSQL connection string
# - CLICKHOUSE_URL: ClickHouse connection string (optional for newer versions)
# - NEXTAUTH_SECRET: Random secret for authentication
# - NEXTAUTH_URL: Public URL of the Langfuse instance
# - SALT: Random salt for hashing

