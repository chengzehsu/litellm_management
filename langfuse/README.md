# Langfuse Self-Hosted Deployment

這個目錄包含 Langfuse self-hosted 部署配置。

## 快速開始

### 1. 設置環境變數

```bash
cd langfuse
cp .env.example .env
```

編輯 `.env` 文件，設置：
- `POSTGRES_PASSWORD` - PostgreSQL 密碼
- `CLICKHOUSE_PASSWORD` - ClickHouse 密碼
- `NEXTAUTH_SECRET` - 生成隨機密鑰（用於 NextAuth）
- `SALT` - 生成隨機 salt
- `NEXTAUTH_URL` - 你的 Langfuse URL（生產環境使用實際域名）

### 2. 生成密鑰

```bash
# 生成 NEXTAUTH_SECRET
openssl rand -base64 32

# 生成 SALT
openssl rand -base64 32
```

### 3. 啟動服務

```bash
docker-compose up -d
```

### 4. 訪問 Langfuse

- Web UI: http://localhost:3000
- 首次訪問會提示創建帳號

### 5. 獲取 API Keys

1. 登入 Langfuse Web UI
2. 前往 Settings → API Keys
3. 創建新的 API Key
4. 複製 Public Key 和 Secret Key

## 配置 LiteLLM 連接

在 LiteLLM Proxy 的環境變數中設置：

```bash
LANGFUSE_PUBLIC_KEY=pk-your-public-key
LANGFUSE_SECRET_KEY=sk-your-secret-key
LANGFUSE_HOST=http://your-langfuse-host:3000
```

## 生產環境部署

### Zeabur 部署

1. 在 Zeabur 上創建新專案
2. 連接 `langfuse` 目錄
3. 設置環境變數（從 `.env.example`）
4. Zeabur 會自動檢測 `docker-compose.yml` 並部署

### 注意事項

- 確保設置強密碼
- 生產環境使用 HTTPS（設置 `NEXTAUTH_URL` 為 HTTPS）
- 定期備份 PostgreSQL 和 ClickHouse 數據
- 監控資源使用情況

## 服務說明

- **PostgreSQL**: 存儲應用數據
- **ClickHouse**: 存儲 traces 和分析數據
- **Langfuse**: Web UI 和 API 服務

## 健康檢查

```bash
# 檢查服務狀態
docker-compose ps

# 查看日誌
docker-compose logs -f langfuse

# 檢查健康狀態
curl http://localhost:3000/api/public/health
```

## 數據備份

```bash
# 備份 PostgreSQL
docker-compose exec postgres pg_dump -U langfuse langfuse > backup.sql

# 備份 ClickHouse（可選）
docker-compose exec clickhouse clickhouse-client --query "BACKUP DATABASE langfuse TO Disk('backups', 'backup.zip')"
```

## 故障排除

### 服務無法啟動

1. 檢查端口是否被占用（3000, 5432, 8123）
2. 檢查環境變數是否正確設置
3. 查看日誌：`docker-compose logs`

### 無法連接數據庫

1. 確認 PostgreSQL 和 ClickHouse 健康檢查通過
2. 檢查 `DATABASE_URL` 和 `CLICKHOUSE_URL` 格式

### API Keys 無效

1. 確認在 Langfuse UI 中創建了 API Key
2. 檢查 `LANGFUSE_HOST` 是否正確（包含協議和端口）

