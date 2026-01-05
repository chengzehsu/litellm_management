# Langfuse Deployment for Zeabur

This directory contains configuration for deploying Langfuse to Zeabur.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Zeabur Project                        │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  PostgreSQL  │  │   Langfuse   │  │   LiteLLM    │  │
│  │  (Zeabur)    │◄─│   (Docker)   │◄─│    Proxy     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                           │                    │        │
└───────────────────────────┼────────────────────┼────────┘
                            │                    │
                      Dashboard              API Requests
                            │                    │
                            └────────────────────┘
                                    User
```

## Prerequisites

1. A Zeabur account
2. PostgreSQL service from Zeabur Marketplace

## Deployment Steps

### Step 1: Deploy PostgreSQL

1. Go to your Zeabur project
2. Click "Add Service" → "Marketplace"
3. Search for "PostgreSQL" and deploy it
4. Wait for PostgreSQL to be ready
5. Copy the connection string from the service details

### Step 2: Deploy Langfuse

1. In the same Zeabur project, click "Add Service" → "Git"
2. Connect your GitHub repository: `chengzehsu/litellm_management`
3. **Important**: Set Root Directory to `langfuse`
4. Set the following environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | PostgreSQL connection string from Step 1 | Yes |
| `NEXTAUTH_SECRET` | Random secret (run: `openssl rand -base64 32`) | Yes |
| `NEXTAUTH_URL` | Your Langfuse URL (e.g., `https://langfuse-xxx.zeabur.app`) | Yes |
| `SALT` | Random salt (run: `openssl rand -base64 32`) | Yes |
| `TELEMETRY_ENABLED` | Set to `false` | No |

5. Deploy and wait for the service to be ready

### Step 3: Get Langfuse API Keys

1. Visit your Langfuse URL
2. Create an account (first user becomes admin)
3. Go to Settings → API Keys
4. Create a new API key
5. Copy the Public Key (`pk-...`) and Secret Key (`sk-...`)

### Step 4: Deploy LiteLLM Proxy

See the main [ZEABUR_DEPLOY.md](../ZEABUR_DEPLOY.md) for LiteLLM Proxy deployment.

## Environment Variables

Generate secrets with:

```bash
# Generate NEXTAUTH_SECRET
openssl rand -base64 32

# Generate SALT
openssl rand -base64 32
```

## Troubleshooting

### Database Connection Error

If you see "Can't reach database server":

1. Ensure PostgreSQL service is running in Zeabur
2. Copy the exact connection string from PostgreSQL service details
3. Set `DATABASE_URL` in Langfuse environment variables
4. Redeploy Langfuse

### NEXTAUTH_URL Mismatch

If you see authentication errors:

1. Get the actual Langfuse service URL from Zeabur
2. Update `NEXTAUTH_URL` to match exactly (include `https://`)
3. Redeploy Langfuse

## Files

- `Dockerfile` - Uses official Langfuse image
- `zeabur.json` - Zeabur deployment configuration
- `env.example` - Environment variable template
