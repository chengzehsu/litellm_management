# Zeabur Deployment Guide

Complete guide for deploying LiteLLM Proxy with Langfuse on Zeabur.

## Your Project

- **Project URL**: https://zeabur.com/projects/695b3380a87d9ee2983d59de
- **PostgreSQL**: Already deployed (use existing)

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Zeabur Project                            │
│                                                                  │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │  PostgreSQL  │────►│   Langfuse   │◄────│   LiteLLM    │    │
│  │  (Existing)  │     │   Dashboard  │     │    Proxy     │    │
│  └──────────────┘     └──────────────┘     └──────────────┘    │
│                              │                    │             │
└──────────────────────────────┼────────────────────┼─────────────┘
                               │                    │
                         Dashboard              API Requests
                               │                    │
                               └────────────────────┘
                                      User
```

## Deployment Order

1. **PostgreSQL** - Already deployed ✓
2. **Langfuse** - Deploy from `langfuse/` directory
3. **LiteLLM Proxy** - Deploy from root directory

## Step 1: Get PostgreSQL Connection String

Your PostgreSQL is already running.

1. Go to your project: https://zeabur.com/projects/695b3380a87d9ee2983d59de
2. Click on the **PostgreSQL service**
3. Find **Connection String** (or **DATABASE_URL**)
   - Format: `postgresql://user:password@host:port/database`
   - Copy this for the next steps

## Step 2: Deploy Langfuse

1. In your project, click **"Add Service"** → **"Git"**
2. Connect repository: `chengzehsu/litellm_management`
3. **Set Root Directory**: `langfuse`
4. **Set Environment Variables**:

| Variable | Value |
|----------|-------|
| `DATABASE_URL` | Your PostgreSQL connection string from Step 1 |
| `NEXTAUTH_SECRET` | Run: `openssl rand -base64 32` |
| `NEXTAUTH_URL` | Set after deploy (e.g., `https://langfuse-xxx.zeabur.app`) |
| `SALT` | Run: `openssl rand -base64 32` |
| `TELEMETRY_ENABLED` | `false` |

5. Click **Deploy**
6. After deployment, copy the Langfuse service URL
7. **Update `NEXTAUTH_URL`** with the actual URL and redeploy

### Get Langfuse API Keys

1. Visit your Langfuse URL
2. Create an account (first user = admin)
3. Go to **Settings** → **API Keys**
4. Create API Key and copy:
   - Public Key (`pk-...`)
   - Secret Key (`sk-...`)

## Step 3: Deploy LiteLLM Proxy

1. Click **"Add Service"** → **"Git"**
2. Connect: `chengzehsu/litellm_management`
3. **Root Directory**: Leave empty (uses root `/`)
4. **Environment Variables**:

| Variable | Value |
|----------|-------|
| `LITELLM_MASTER_KEY` | Your API key (e.g., `sk-xxx`) |
| `DATABASE_URL` | Same PostgreSQL connection string |
| `LANGFUSE_PUBLIC_KEY` | From Langfuse API Keys |
| `LANGFUSE_SECRET_KEY` | From Langfuse API Keys |
| `LANGFUSE_HOST` | Your Langfuse URL |
| `GOOGLE_API_KEY` | Your Google API key |
| `DISABLE_ADMIN_UI` | `True` |

5. Click **Deploy**

## Step 4: Verify

### Test LiteLLM Proxy

```bash
# Health check
curl https://YOUR-LITELLM-URL.zeabur.app/health

# Test API
curl https://YOUR-LITELLM-URL.zeabur.app/v1/chat/completions \
  -H "Authorization: Bearer YOUR_LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "gemini-2.5-flash", "messages": [{"role": "user", "content": "Hello!"}]}'
```

### Check Langfuse Dashboard

1. Visit your Langfuse URL
2. Go to **Traces**
3. You should see the test request

## Generate Secrets

```bash
# NEXTAUTH_SECRET
openssl rand -base64 32

# SALT
openssl rand -base64 32

# LITELLM_MASTER_KEY
echo "sk-$(openssl rand -hex 16)"
```

## Troubleshooting

### "Can't reach database server"

1. Check PostgreSQL service is running
2. Copy exact connection string from PostgreSQL service details
3. Update `DATABASE_URL` in Langfuse
4. Redeploy

### "Invalid NEXTAUTH_URL"

1. Get actual Langfuse URL from Zeabur
2. Update `NEXTAUTH_URL` to match exactly (include `https://`)
3. Redeploy

### LiteLLM can't connect to Langfuse

1. Verify `LANGFUSE_HOST` URL is correct
2. Verify API keys are correct
3. Redeploy

## Quick Checklist

- [x] PostgreSQL running (existing)
- [ ] Langfuse deployed with correct DATABASE_URL
- [ ] NEXTAUTH_URL set to actual Langfuse URL
- [ ] Langfuse API keys created
- [ ] LiteLLM Proxy deployed
- [ ] Test request successful
- [ ] Traces visible in Langfuse
