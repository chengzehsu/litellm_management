# Zeabur Deployment Guide

Complete guide for deploying LiteLLM Proxy with Langfuse on Zeabur.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Zeabur Project                            │
│                                                                  │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │  PostgreSQL  │────►│   Langfuse   │◄────│   LiteLLM    │    │
│  │  (Zeabur     │     │   Dashboard  │     │    Proxy     │    │
│  │  Marketplace)│     │              │     │              │    │
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

**Important**: Deploy in this exact order:

1. PostgreSQL (Zeabur Marketplace)
2. Langfuse (langfuse/ directory)
3. LiteLLM Proxy (root directory)

## Step 1: Deploy PostgreSQL

1. Go to [Zeabur](https://zeabur.com)
2. Create a new project or enter your existing project
3. Click **"Add Service"** → **"Marketplace"**
4. Search for **"PostgreSQL"** and click to deploy
5. Wait for PostgreSQL to show "Running" status
6. Click on the PostgreSQL service and copy the **Connection String**
   - Format: `postgresql://user:password@host:port/database`
   - Save this for later steps

## Step 2: Deploy Langfuse

1. In the same project, click **"Add Service"** → **"Git"**
2. Connect your GitHub repository: `chengzehsu/litellm_management`
3. **Set Root Directory**: `langfuse`
4. **Set Environment Variables**:

| Variable | Value | How to Get |
|----------|-------|------------|
| `DATABASE_URL` | PostgreSQL connection string | Copy from Step 1 |
| `NEXTAUTH_SECRET` | Random secret | Run: `openssl rand -base64 32` |
| `NEXTAUTH_URL` | `https://langfuse-xxx.zeabur.app` | Will be assigned after deploy, update later |
| `SALT` | Random salt | Run: `openssl rand -base64 32` |
| `TELEMETRY_ENABLED` | `false` | Optional |

5. Click **Deploy**
6. After deployment, get the Langfuse URL from service details
7. **Update `NEXTAUTH_URL`** with the actual URL and redeploy

### Get Langfuse API Keys

1. Visit your Langfuse URL (e.g., `https://langfuse-xxx.zeabur.app`)
2. Create an account (first user becomes admin)
3. Go to **Settings** → **API Keys**
4. Click **Create API Key**
5. Copy:
   - Public Key (`pk-...`)
   - Secret Key (`sk-...`)

## Step 3: Deploy LiteLLM Proxy

1. In the same project, click **"Add Service"** → **"Git"**
2. Connect the same repository: `chengzehsu/litellm_management`
3. **Set Root Directory**: `/` (root, leave empty)
4. **Set Environment Variables**:

| Variable | Value | Description |
|----------|-------|-------------|
| `LITELLM_MASTER_KEY` | `sk-your-key` | Your LiteLLM API key |
| `DATABASE_URL` | PostgreSQL connection string | Same as Step 1 |
| `LANGFUSE_PUBLIC_KEY` | `pk-xxx` | From Langfuse API Keys |
| `LANGFUSE_SECRET_KEY` | `sk-xxx` | From Langfuse API Keys |
| `LANGFUSE_HOST` | `https://langfuse-xxx.zeabur.app` | Your Langfuse URL |
| `GOOGLE_API_KEY` | Your Google API key | For Gemini models |
| `DISABLE_ADMIN_UI` | `True` | Use Langfuse instead |

5. Click **Deploy**

## Step 4: Verify Deployment

### Test LiteLLM Proxy

```bash
# Health check
curl https://litellm-xxx.zeabur.app/health

# Test API (replace with your values)
curl https://litellm-xxx.zeabur.app/v1/chat/completions \
  -H "Authorization: Bearer YOUR_LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-2.5-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Check Langfuse Dashboard

1. Visit your Langfuse URL
2. Go to **Traces**
3. You should see the test request from above

## Environment Variable Summary

### PostgreSQL (Auto-configured by Zeabur)

No manual configuration needed.

### Langfuse

```bash
DATABASE_URL=postgresql://xxx:xxx@xxx:5432/xxx
NEXTAUTH_SECRET=<openssl rand -base64 32>
NEXTAUTH_URL=https://langfuse-xxx.zeabur.app
SALT=<openssl rand -base64 32>
TELEMETRY_ENABLED=false
```

### LiteLLM Proxy

```bash
LITELLM_MASTER_KEY=sk-your-master-key
DATABASE_URL=postgresql://xxx:xxx@xxx:5432/xxx
LANGFUSE_PUBLIC_KEY=pk-xxx
LANGFUSE_SECRET_KEY=sk-xxx
LANGFUSE_HOST=https://langfuse-xxx.zeabur.app
GOOGLE_API_KEY=your-google-api-key
DISABLE_ADMIN_UI=True
```

## Generate Secrets

```bash
# Generate NEXTAUTH_SECRET
openssl rand -base64 32

# Generate SALT
openssl rand -base64 32

# Generate LITELLM_MASTER_KEY
echo "sk-$(openssl rand -hex 16)"
```

## Troubleshooting

### "Can't reach database server"

**Cause**: Langfuse cannot connect to PostgreSQL.

**Solution**:
1. Ensure PostgreSQL is running in Zeabur
2. Copy the exact connection string from PostgreSQL service
3. Update `DATABASE_URL` in Langfuse environment variables
4. Redeploy Langfuse

### Langfuse shows "Invalid NEXTAUTH_URL"

**Cause**: `NEXTAUTH_URL` doesn't match the actual service URL.

**Solution**:
1. Get the actual Langfuse URL from Zeabur dashboard
2. Update `NEXTAUTH_URL` to match exactly (include `https://`)
3. Redeploy Langfuse

### LiteLLM can't connect to Langfuse

**Cause**: Incorrect Langfuse configuration.

**Solution**:
1. Verify `LANGFUSE_HOST` is the correct Langfuse URL
2. Verify `LANGFUSE_PUBLIC_KEY` and `LANGFUSE_SECRET_KEY` are correct
3. Redeploy LiteLLM Proxy

### No data in Langfuse dashboard

**Cause**: Traces not being sent.

**Solution**:
1. Check LiteLLM Proxy logs for errors
2. Verify Langfuse callback is enabled in `config.yaml`
3. Send a test request and check again

## Enable Auto-Deploy

For each service in Zeabur:

1. Click on the service
2. Go to **Settings** → **Deployment**
3. Enable **Auto Deploy**
4. Select branch: `main`

Now every push to GitHub will trigger automatic deployment.

## Service URLs

After deployment, you will have:

- **Langfuse Dashboard**: `https://langfuse-xxx.zeabur.app`
- **LiteLLM Proxy API**: `https://litellm-xxx.zeabur.app`

## Quick Checklist

- [ ] PostgreSQL deployed and running
- [ ] Langfuse deployed with correct DATABASE_URL
- [ ] NEXTAUTH_URL updated to actual Langfuse URL
- [ ] Langfuse API keys created
- [ ] LiteLLM Proxy deployed with Langfuse configuration
- [ ] Test request successful
- [ ] Traces visible in Langfuse dashboard
- [ ] Auto-deploy enabled (optional)
