# 🚀 Zeabur 部署指南

## 部署架構

你需要部署以下服務：

1. **LiteLLM Proxy** - LLM API Gateway
2. **Langfuse** - Observability Dashboard（Self-Hosted）
3. **Dashboard** - 可選的簡單 Dashboard

## 步驟 1: 部署 LiteLLM Proxy

### 在 Zeabur 上：

1. 前往 https://zeabur.com
2. 創建新專案或進入現有專案
3. 點擊「**新增服務**」→「**從 GitHub 導入**」
4. 選擇：`chengzehsu/litellm_management`
5. Zeabur 會自動檢測根目錄的 `Dockerfile`

### 設置環境變數：

```
LITELLM_MASTER_KEY=你的master-key
DATABASE_URL=你的資料庫連接字串
LANGFUSE_PUBLIC_KEY=你的Langfuse公鑰
LANGFUSE_SECRET_KEY=你的Langfuse私鑰
LANGFUSE_HOST=http://langfuse-service.zeabur.app:3000
DISABLE_ADMIN_UI=True
GOOGLE_API_KEY=你的google-api-key
```

### 設置根目錄：

- **Root Directory**: `/` (根目錄)
- **Build Command**: 自動檢測
- **Start Command**: 自動檢測

## 步驟 2: 部署 Langfuse (Self-Hosted)

### 在 Zeabur 上：

1. 在同一個專案中，點擊「**新增服務**」
2. 選擇「**從 GitHub 導入**」
3. 選擇：`chengzehsu/litellm_management`
4. **重要**：設置 **Root Directory** 為：`langfuse`

### Zeabur 會自動檢測：

- `docker-compose.yml` 文件
- 自動部署所有服務（PostgreSQL, ClickHouse, Langfuse）

### 設置環境變數：

在 Langfuse 服務的環境變數中設置：

```
POSTGRES_USER=langfuse
POSTGRES_PASSWORD=你的強密碼
POSTGRES_DB=langfuse
CLICKHOUSE_DB=langfuse
CLICKHOUSE_USER=langfuse
CLICKHOUSE_PASSWORD=你的強密碼
NEXTAUTH_SECRET=生成的隨機密鑰（使用 openssl rand -base64 32）
NEXTAUTH_URL=https://langfuse-service.zeabur.app
SALT=生成的隨機salt（使用 openssl rand -base64 32）
TELEMETRY_ENABLED=false
```

### 生成密鑰：

```bash
# 生成 NEXTAUTH_SECRET
openssl rand -base64 32

# 生成 SALT
openssl rand -base64 32
```

### 獲取 Langfuse URL：

部署完成後，Zeabur 會提供 Langfuse 服務的 URL，例如：
- `https://langfuse-xxxxx.zeabur.app`

**重要**：將這個 URL 更新到 LiteLLM Proxy 的 `LANGFUSE_HOST` 環境變數中。

## 步驟 3: 配置連接

### 1. 獲取 Langfuse API Keys

1. 訪問 Langfuse Web UI（Zeabur 提供的 URL）
2. 首次訪問會提示創建帳號
3. 登入後，前往 **Settings** → **API Keys**
4. 創建新的 API Key
5. 複製 **Public Key** (`pk-...`) 和 **Secret Key** (`sk-...`)

### 2. 更新 LiteLLM Proxy 環境變數

在 LiteLLM Proxy 服務的環境變數中更新：

```
LANGFUSE_PUBLIC_KEY=pk-你的公鑰
LANGFUSE_SECRET_KEY=sk-你的私鑰
LANGFUSE_HOST=https://langfuse-xxxxx.zeabur.app
```

### 3. 重新部署 LiteLLM Proxy

更新環境變數後，Zeabur 會自動重新部署。

## 步驟 4: 驗證部署

### 檢查 LiteLLM Proxy

```bash
# 健康檢查
curl https://litellm-service.zeabur.app/healthz

# 測試 Gemini 模型
curl https://litellm-service.zeabur.app/v1/chat/completions \
  -H "Authorization: Bearer YOUR_LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-3-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### 檢查 Langfuse

1. 訪問 Langfuse Web UI
2. 前往 **Traces** 頁面
3. 應該能看到剛才的測試請求記錄

### 檢查 Dashboard（可選）

如果部署了 Dashboard：

1. 訪問 Dashboard URL
2. 應該能看到 Gemini 模型的用量統計

## 步驟 5: 啟用自動部署

### 對於每個服務：

1. 在服務設置中找到「**自動部署**」
2. 啟用自動部署
3. 選擇監聽分支：`main`

這樣每次推送代碼到 GitHub，Zeabur 會自動重新部署。

## 故障排除

### LiteLLM Proxy 無法連接 Langfuse

1. 確認 `LANGFUSE_HOST` 正確（包含協議和端口，如果需要的話）
2. 確認 Langfuse 服務已啟動並運行
3. 檢查 Langfuse API Keys 是否正確

### Langfuse 服務無法啟動

1. 檢查所有環境變數是否設置
2. 確認 PostgreSQL 和 ClickHouse 服務正常
3. 查看 Zeabur 日誌了解錯誤

### 數據庫連接問題

1. 確認 `DATABASE_URL` 格式正確
2. 確認資料庫服務可訪問
3. 檢查網路連接

## 服務 URL 結構

部署完成後，你會得到：

- **LiteLLM Proxy**: `https://litellm-xxxxx.zeabur.app`
- **Langfuse**: `https://langfuse-xxxxx.zeabur.app`
- **Dashboard** (可選): `https://dashboard-xxxxx.zeabur.app`

## 重要提醒

1. **安全性**：
   - 使用強密碼
   - 定期輪換 API Keys
   - 不要提交 `.env` 文件

2. **備份**：
   - 定期備份 PostgreSQL 數據
   - 備份 ClickHouse 數據（可選）

3. **監控**：
   - 監控服務資源使用
   - 設置告警

## 快速檢查清單

- [ ] LiteLLM Proxy 已部署
- [ ] Langfuse 已部署
- [ ] 所有環境變數已設置
- [ ] Langfuse API Keys 已獲取並配置
- [ ] 測試請求成功
- [ ] Langfuse 中能看到 traces
- [ ] 自動部署已啟用

## 需要幫助？

- 查看 Zeabur 日誌：在服務頁面點擊「日誌」
- 檢查 GitHub Actions：https://github.com/chengzehsu/litellm_management/actions
- 查看 Langfuse 文檔：https://langfuse.com/docs

