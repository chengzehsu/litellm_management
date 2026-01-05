# LiteLLM + Langfuse Integration

Deploy LiteLLM Proxy with Langfuse observability on Zeabur.

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

- **LiteLLM Proxy**: API Gateway for LLM requests
- **Langfuse**: Observability dashboard (replaces LiteLLM Admin UI)
- **PostgreSQL**: Database for both services

## Features

- Automatic trace logging to Langfuse
- Support for multiple LLM providers (OpenAI, Anthropic, Google Gemini, etc.)
- Request tracking and cost analysis
- CI/CD with GitHub Actions
- Easy deployment on Zeabur

## Quick Start

### Deploy to Zeabur

See [ZEABUR_DEPLOY.md](ZEABUR_DEPLOY.md) for complete deployment instructions.

**Deployment order:**

1. Deploy PostgreSQL (Zeabur Marketplace)
2. Deploy Langfuse (`langfuse/` directory)
3. Deploy LiteLLM Proxy (root directory)

### Local Development

1. Copy environment variables:

```bash
cp env.example .env
```

2. Edit `.env` with your values:

```env
LITELLM_MASTER_KEY=sk-your-key
DATABASE_URL=postgresql://user:pass@host:5432/db
LANGFUSE_PUBLIC_KEY=pk-xxx
LANGFUSE_SECRET_KEY=sk-xxx
LANGFUSE_HOST=http://localhost:3000
GOOGLE_API_KEY=your-google-api-key
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Start LiteLLM Proxy:

```bash
./start.sh
```

5. Test:

```bash
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer sk-your-key" \
  -H "Content-Type: application/json" \
  -d '{"model": "gemini-2.5-flash", "messages": [{"role": "user", "content": "Hello!"}]}'
```

## Configured Models

### Gemini 3 Series (Latest)

| Model | Description |
|-------|-------------|
| `gemini-3-pro` | Advanced reasoning and complex code |
| `gemini-3-flash` | Fast multimodal processing |
| `gemini-3-deep-think` | Enhanced logical reasoning |

### Gemini 2.5 Series (Stable)

| Model | Description |
|-------|-------------|
| `gemini-2.5-pro` | Long context (1M-2M tokens) |
| `gemini-2.5-flash` | High performance, cost-effective |
| `gemini-2.5-flash-lite` | Ultra-low latency |

### Special Purpose

| Model | Description |
|-------|-------------|
| `gemini-3-pro-image` | Image generation and analysis |
| `gemini-live-3-flash` | Real-time voice and streaming |

## Environment Variables

### LiteLLM Proxy

| Variable | Description | Required |
|----------|-------------|----------|
| `LITELLM_MASTER_KEY` | API authentication key | Yes |
| `DATABASE_URL` | PostgreSQL connection | Yes |
| `LANGFUSE_PUBLIC_KEY` | Langfuse public key | Yes |
| `LANGFUSE_SECRET_KEY` | Langfuse secret key | Yes |
| `LANGFUSE_HOST` | Langfuse URL | Yes |
| `GOOGLE_API_KEY` | For Gemini models | Yes |
| `DISABLE_ADMIN_UI` | Set to `True` | Yes |

### Langfuse

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | PostgreSQL connection | Yes |
| `NEXTAUTH_SECRET` | Auth secret | Yes |
| `NEXTAUTH_URL` | Public Langfuse URL | Yes |
| `SALT` | Hashing salt | Yes |

## CI/CD

Push to `main` triggers:

1. Configuration validation
2. Docker build test
3. YAML linting
4. Security checks

Zeabur auto-deploys after checks pass.

## Project Structure

```
.
├── config.yaml          # LiteLLM configuration
├── Dockerfile           # LiteLLM Proxy container
├── requirements.txt     # Python dependencies
├── start.sh             # Startup script
├── env.example          # Environment template
├── ZEABUR_DEPLOY.md     # Deployment guide
├── langfuse/            # Langfuse deployment
│   ├── Dockerfile
│   ├── zeabur.json
│   ├── env.example
│   └── README.md
└── .github/
    └── workflows/
        └── deploy.yml   # CI/CD pipeline
```

## Troubleshooting

### Database connection error

1. Check PostgreSQL is running in Zeabur
2. Copy exact connection string from PostgreSQL service
3. Update `DATABASE_URL` and redeploy

### No traces in Langfuse

1. Verify Langfuse keys are correct
2. Check `LANGFUSE_HOST` URL is correct
3. Check LiteLLM Proxy logs for errors

### Model request fails

1. Verify `GOOGLE_API_KEY` is set
2. Check model name in `config.yaml`
3. View LiteLLM Proxy logs

## Links

- [LiteLLM Docs](https://docs.litellm.ai/)
- [Langfuse Docs](https://langfuse.com/docs)
- [Zeabur Docs](https://zeabur.com/docs)

## License

MIT
