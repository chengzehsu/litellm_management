# LiteLLM + Langfuse 整合部署

這個專案將 LiteLLM Proxy 設置為數據收集器，自動將所有 LLM 請求的 traces 發送到 Langfuse 進行觀察和分析。Langfuse 取代了 LiteLLM 的 Admin UI，提供更完整的 observability 功能。

## 架構概述

```
LLM Requests → LiteLLM Proxy → Langfuse (UI)
                      ↓
                  Database (已存在)
```

- **LiteLLM Proxy**: 作為 API Gateway，處理所有 LLM 請求
- **Langfuse**: 提供完整的 observability UI，取代 LiteLLM Admin UI
- **Database**: 儲存 LiteLLM 的配置和日誌數據

## 功能特點

- ✅ 自動將所有 LLM 請求 traces 發送到 Langfuse
- ✅ 禁用 LiteLLM Admin UI（使用 Langfuse 作為前端）
- ✅ 支援多種 LLM 提供商（OpenAI, Anthropic, Google 等）
- ✅ 完整的請求追蹤和成本分析
- ✅ 易於在 Zeabur 上部署
- ✅ GitHub Actions CI/CD 自動化流程
- ✅ 自動化測試和驗證

## 前置需求

1. **Langfuse 帳號**
   - 在 [Langfuse Cloud](https://cloud.langfuse.com) 註冊，或
   - 部署 self-hosted Langfuse 實例
   - 獲取 API keys（Public Key 和 Secret Key）

2. **資料庫**
   - PostgreSQL 或 SQLite
   - 已在 Zeabur 上設置

3. **LLM Provider API Keys**
   - 根據你要使用的模型提供商準備對應的 API keys

## 快速開始

### 1. 克隆或下載專案

```bash
cd litellm_management
```

### 2. 設置環境變數

複製 `env.example` 到 `.env` 並填入實際值：

```bash
cp env.example .env
```

編輯 `.env` 文件，設置以下變數：

```env
LITELLM_MASTER_KEY=sk-your-master-key-here
DATABASE_URL=postgresql://user:password@host:port/database
LANGFUSE_PUBLIC_KEY=pk-your-langfuse-public-key
LANGFUSE_SECRET_KEY=sk-your-langfuse-secret-key
DISABLE_ADMIN_UI=True
```

### 3. 配置模型

`config.yaml` 已經預配置了 Gemini 模型：
- `gemini-pro` - Gemini Pro
- `gemini-1.5-pro` - Gemini 1.5 Pro
- `gemini-1.5-flash` - Gemini 1.5 Flash

在 `.env` 中設置 Google API Key：

```env
GOOGLE_API_KEY=your-google-api-key-here
```

**獲取 Google API Key：**
1. 前往 https://aistudio.google.com/app/apikey
2. 登入你的 Google 帳號
3. 創建新的 API Key
4. 複製並設置到環境變數中

**使用其他模型：**

你也可以在 `config.yaml` 中添加其他模型：

```yaml
model_list:
  # Gemini models (already configured)
  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-pro
      api_key: os.environ/GOOGLE_API_KEY

  # Add other models as needed
  # - model_name: gpt-4
  #   litellm_params:
  #     model: gpt-4
  #     api_key: os.environ/OPENAI_API_KEY
```

### 4. 本地測試

安裝依賴：

```bash
pip install -r requirements.txt
```

啟動 LiteLLM Proxy：

```bash
./start.sh
```

或直接使用：

```bash
litellm --config config.yaml
```

Proxy 將在 `http://localhost:4000` 啟動。

### 5. 測試請求

使用 curl 測試：

```bash
curl http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-your-master-key-here" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

檢查 Langfuse UI，應該能看到 trace 記錄。

## CI/CD 自動部署

這個專案配置了 GitHub Actions 工作流程，實現自動化的 CI/CD 流程。

### GitHub Actions 工作流程

當你推送代碼到 GitHub 時，會自動執行以下檢查：

1. **配置驗證** - 驗證 `config.yaml` 格式和必要配置
2. **Docker 構建測試** - 測試 Docker 映像是否能成功構建
3. **代碼檢查** - YAML 和 Shell 腳本語法檢查
4. **安全檢查** - 檢查是否有 secrets 洩露

工作流程文件位於 `.github/workflows/deploy.yml`。

### 設置 Zeabur 自動部署

1. **連接 GitHub Repository**
   - 登入 [Zeabur](https://zeabur.com)
   - 創建新專案或進入現有專案
   - 點擊「新增服務」→「從 GitHub 導入」
   - 選擇你的 repository

2. **配置自動部署**
   - Zeabur 會自動檢測 Dockerfile
   - 在服務設置中啟用「自動部署」
   - 選擇要監聽的分支（通常是 `main` 或 `master`）

3. **設置環境變數**
   - 在 Zeabur 服務設置中，添加所有必要的環境變數：
     - `LITELLM_MASTER_KEY`
     - `DATABASE_URL`
     - `LANGFUSE_PUBLIC_KEY`
     - `LANGFUSE_SECRET_KEY`
     - `DISABLE_ADMIN_UI=True`
     - 以及任何 LLM provider API keys

4. **部署流程**
   ```
   Git Push → GitHub Actions (驗證) → Zeabur (自動部署)
   ```
   - 推送代碼到 GitHub
   - GitHub Actions 自動運行驗證
   - Zeabur 檢測到變更並自動部署
   - 在 Zeabur dashboard 查看部署狀態

### 部署方法

#### 方法 1: 使用 Dockerfile（推薦）

Zeabur 會自動檢測 Dockerfile 並構建映像：
- 自動構建 Docker 映像
- 自動設置啟動命令
- 自動配置端口

#### 方法 2: 使用 Buildpack

如果 Zeabur 支援 Python buildpack：

1. 確保 `requirements.txt` 存在
2. 設置啟動命令：`litellm --config config.yaml --port $PORT`
3. 設置環境變數（同上）

### 環境變數設置

在 Zeabur 專案設置中，添加以下環境變數：

| 變數名稱 | 說明 | 必填 |
|---------|------|------|
| `LITELLM_MASTER_KEY` | LiteLLM Proxy master key | ✅ |
| `DATABASE_URL` | 資料庫連接字串 | ✅ |
| `LANGFUSE_PUBLIC_KEY` | Langfuse 公鑰 | ✅ |
| `LANGFUSE_SECRET_KEY` | Langfuse 私鑰 | ✅ |
| `DISABLE_ADMIN_UI` | 禁用 Admin UI | ✅ |
| `LANGFUSE_HOST` | Langfuse 服務地址（self-hosted 時需要） | ❌ |
| `OPENAI_API_KEY` | OpenAI API key（如使用 OpenAI 模型） | ❌ |
| `ANTHROPIC_API_KEY` | Anthropic API key（如使用 Claude 模型） | ❌ |
| `GOOGLE_API_KEY` | Google API key（如使用 Gemini 模型） | ❌ |

## Langfuse 設置

### 獲取 API Keys

1. 登入 [Langfuse Cloud](https://cloud.langfuse.com) 或你的 self-hosted 實例
2. 創建新專案（如果還沒有）
3. 進入專案設置 → API Keys
4. 創建新的 API Key，獲取：
   - **Public Key** (`pk-...`)
   - **Secret Key** (`sk-...`)

### Self-Hosted Langfuse

如果使用 self-hosted Langfuse，還需要設置：

```env
LANGFUSE_HOST=https://your-langfuse-instance.com
```

## 配置說明

### config.yaml

主要配置選項：

- `general_settings.master_key`: Proxy 認證 key
- `general_settings.database_url`: 資料庫連接
- `litellm_settings.success_callback`: 啟用 Langfuse callback
- `model_list`: 配置可用的模型

### 添加新模型

在 `config.yaml` 的 `model_list` 中添加：

```yaml
model_list:
  - model_name: your-model-name
    litellm_params:
      model: provider-model-id
      api_key: os.environ/YOUR_PROVIDER_API_KEY
```

然後在環境變數中設置對應的 API key。

## 驗證部署

### 檢查 GitHub Actions

1. 推送代碼後，前往 GitHub repository
2. 點擊「Actions」標籤
3. 查看工作流程執行狀態
4. 確保所有檢查都通過（綠色 ✓）

### 檢查 Zeabur 部署

1. **檢查服務狀態**
   - 登入 Zeabur dashboard
   - 查看服務狀態，應該顯示「運行中」
   - 檢查日誌確認沒有錯誤

2. **檢查 Proxy 狀態**
   ```bash
   curl http://your-zeabur-url/health
   ```

3. **發送測試請求**
   ```bash
   curl http://your-zeabur-url/v1/chat/completions \
     -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
     -H "Content-Type: application/json" \
     -d '{"model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": "test"}]}'
   ```

4. **檢查 Langfuse**
   - 登入 Langfuse UI
   - 查看 Traces 頁面，應該能看到剛才的請求記錄

## 故障排除

### Langfuse 沒有收到 traces

1. 檢查環境變數是否正確設置
2. 確認 `LANGFUSE_PUBLIC_KEY` 和 `LANGFUSE_SECRET_KEY` 正確
3. 檢查網路連接（如果使用 self-hosted Langfuse）
4. 查看 LiteLLM 日誌是否有錯誤訊息

### 資料庫連接問題

1. 確認 `DATABASE_URL` 格式正確
2. 檢查資料庫服務是否運行
3. 確認網路連接和防火牆設置

### 模型請求失敗

1. 確認對應的 provider API key 已設置
2. 檢查 `config.yaml` 中的模型配置
3. 查看 LiteLLM 日誌了解詳細錯誤

## 安全建議

1. **永遠不要提交 `.env` 文件到版本控制**
2. **使用強密碼作為 `LITELLM_MASTER_KEY`**
3. **定期輪換 API keys**
4. **使用環境變數管理敏感資訊**
5. **啟用 HTTPS（在 Zeabur 上通常自動處理）**

## 相關資源

- [LiteLLM 文檔](https://docs.litellm.ai/)
- [Langfuse 文檔](https://langfuse.com/docs)
- [Zeabur 文檔](https://zeabur.com/docs)

## 授權

MIT License

