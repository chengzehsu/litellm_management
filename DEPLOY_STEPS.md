# 🚀 快速部署步驟

## ✅ GitHub 狀態

- ✅ Repository: https://github.com/chengzehsu/litellm_management
- ✅ 所有代碼已推送
- ✅ GitHub Actions 正在驗證

## 📋 Zeabur 部署步驟

### 服務 1: LiteLLM Proxy

1. **前往 Zeabur**: https://zeabur.com
2. **創建/進入專案**
3. **新增服務** → **從 GitHub 導入**
4. **選擇**: `chengzehsu/litellm_management`
5. **Root Directory**: `/` (留空或填 `/`)
6. **環境變數**:
   ```
   LITELLM_MASTER_KEY=你的master-key
   DATABASE_URL=你的資料庫連接
   LANGFUSE_PUBLIC_KEY=待Langfuse部署後獲取
   LANGFUSE_SECRET_KEY=待Langfuse部署後獲取
   LANGFUSE_HOST=待Langfuse部署後更新
   DISABLE_ADMIN_UI=True
   GOOGLE_API_KEY=你的google-api-key
   ```

### 服務 2: Langfuse (Self-Hosted)

1. **在同一個專案中**，點擊 **新增服務**
2. **從 GitHub 導入** → `chengzehsu/litellm_management`
3. **Root Directory**: `langfuse` ⚠️ **重要**
4. **環境變數**:
   ```
   POSTGRES_USER=langfuse
   POSTGRES_PASSWORD=生成強密碼
   POSTGRES_DB=langfuse
   CLICKHOUSE_DB=langfuse
   CLICKHOUSE_USER=langfuse
   CLICKHOUSE_PASSWORD=生成強密碼
   NEXTAUTH_SECRET=使用 openssl rand -base64 32 生成
   NEXTAUTH_URL=https://langfuse-xxxxx.zeabur.app (部署後更新)
   SALT=使用 openssl rand -base64 32 生成
   TELEMETRY_ENABLED=false
   ```

5. **生成密鑰**:
   ```bash
   openssl rand -base64 32  # 用於 NEXTAUTH_SECRET
   openssl rand -base64 32  # 用於 SALT
   ```

### 服務 3: 連接配置

1. **等待 Langfuse 部署完成**
2. **獲取 Langfuse URL** (例如: `https://langfuse-xxxxx.zeabur.app`)
3. **訪問 Langfuse Web UI**，創建帳號
4. **獲取 API Keys**: Settings → API Keys
5. **更新 LiteLLM Proxy 環境變數**:
   ```
   LANGFUSE_PUBLIC_KEY=pk-你的公鑰
   LANGFUSE_SECRET_KEY=sk-你的私鑰
   LANGFUSE_HOST=https://langfuse-xxxxx.zeabur.app
   ```
6. **重新部署 LiteLLM Proxy** (Zeabur 會自動重新部署)

## 🎯 部署順序

1. ✅ 先部署 Langfuse
2. ✅ 獲取 Langfuse URL 和 API Keys
3. ✅ 部署/更新 LiteLLM Proxy（使用 Langfuse 配置）

## 📊 驗證

### 測試 LiteLLM Proxy:
```bash
curl https://litellm-xxxxx.zeabur.app/healthz
```

### 測試 Gemini:
```bash
curl https://litellm-xxxxx.zeabur.app/v1/chat/completions \
  -H "Authorization: Bearer YOUR_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "gemini-3-flash", "messages": [{"role": "user", "content": "Hello!"}]}'
```

### 檢查 Langfuse:
- 訪問 Langfuse Web UI
- 查看 Traces 頁面，應該能看到請求記錄

## 📚 詳細文檔

完整部署指南請參考：`ZEABUR_DEPLOY.md`

