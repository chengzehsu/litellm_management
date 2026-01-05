# 完整操作手冊

## 已生成的密鑰（請保存）

```
NEXTAUTH_SECRET: ko7LHMNdG5oxy44zFf7aIdVnoscZNXKZgoJ/H8mJz2A=
SALT: qvwPylFPIAbjZSPGSl+Gml3u7WnZymow979eC0UNe0k=
LITELLM_MASTER_KEY: sk-142f53c886806303b3a53d5a2a796599
```

---

## Step 1: 創建專案並部署 PostgreSQL

1. 前往 https://zeabur.com
2. 登入你的帳號
3. 點擊 **「建立新專案」**
4. 選擇地區（建議選擇亞洲地區如 Hong Kong 或 Tokyo）
5. 點擊 **「Add Service」** → **「Marketplace」**
6. 搜尋 **「PostgreSQL」** 並點擊部署
7. 等待 PostgreSQL 顯示 **「Running」**
8. 點擊 PostgreSQL 服務，找到並複製 **「Connection String」**
   - 格式：`postgresql://user:password@host:port/database`
   - **保存這個連接字串！**

---

## Step 2: 部署 Langfuse

1. 在同一個專案中，點擊 **「Add Service」** → **「Git」**
2. 連接 GitHub（如果尚未連接）
3. 搜尋並選擇：`chengzehsu/litellm_management`
4. **重要**：設定 **Root Directory** 為：`langfuse`
5. 點擊 **「Deploy」**
6. 等待部署完成
7. 點擊 Langfuse 服務，進入 **「Variables」** 設定環境變數：

| 變數名稱 | 值 |
|---------|---|
| `DATABASE_URL` | 貼上 Step 1 複製的 PostgreSQL 連接字串 |
| `NEXTAUTH_SECRET` | `ko7LHMNdG5oxy44zFf7aIdVnoscZNXKZgoJ/H8mJz2A=` |
| `NEXTAUTH_URL` | 先留空，下一步會更新 |
| `SALT` | `qvwPylFPIAbjZSPGSl+Gml3u7WnZymow979eC0UNe0k=` |
| `TELEMETRY_ENABLED` | `false` |

8. 保存後，Zeabur 會自動重新部署
9. 部署完成後，在 Langfuse 服務頁面找到 **服務 URL**（例如：`https://langfuse-xxx.zeabur.app`）
10. 回到環境變數，更新 `NEXTAUTH_URL` 為實際的服務 URL
11. 保存並等待重新部署

---

## Step 3: 創建 Langfuse 帳號並獲取 API Keys

1. 在瀏覽器開啟 Langfuse 服務 URL（例如：`https://langfuse-xxx.zeabur.app`）
2. 點擊 **「Sign Up」** 創建帳號（第一個用戶自動成為管理員）
3. 登入後，點擊左下角 **「Settings」**
4. 點擊 **「API Keys」**
5. 點擊 **「Create API Key」**
6. 複製並保存：
   - **Public Key**（格式：`pk-lf-xxx`）
   - **Secret Key**（格式：`sk-lf-xxx`）

---

## Step 4: 部署 LiteLLM Proxy

1. 回到 Zeabur 專案
2. 點擊 **「Add Service」** → **「Git」**
3. 選擇同一個 repository：`chengzehsu/litellm_management`
4. **Root Directory**：留空（使用根目錄）
5. 點擊 **「Deploy」**
6. 進入 **「Variables」** 設定環境變數：

| 變數名稱 | 值 |
|---------|---|
| `LITELLM_MASTER_KEY` | `sk-142f53c886806303b3a53d5a2a796599` |
| `DATABASE_URL` | 同 Step 1 的 PostgreSQL 連接字串 |
| `LANGFUSE_PUBLIC_KEY` | Step 3 獲取的 Public Key |
| `LANGFUSE_SECRET_KEY` | Step 3 獲取的 Secret Key |
| `LANGFUSE_HOST` | Step 2 的 Langfuse 服務 URL |
| `GOOGLE_API_KEY` | 你的 Google API Key |
| `DISABLE_ADMIN_UI` | `True` |

7. 保存並等待部署完成

---

## Step 5: 驗證部署

### 測試 LiteLLM Proxy

打開終端機，執行：

```bash
# 替換 YOUR-LITELLM-URL 為你的 LiteLLM Proxy URL
curl https://YOUR-LITELLM-URL.zeabur.app/health
```

應該返回健康狀態。

### 測試 API 請求

```bash
curl https://YOUR-LITELLM-URL.zeabur.app/v1/chat/completions \
  -H "Authorization: Bearer sk-142f53c886806303b3a53d5a2a796599" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-2.5-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### 檢查 Langfuse Dashboard

1. 開啟 Langfuse URL
2. 點擊左側 **「Traces」**
3. 應該能看到剛才的測試請求

---

## 查看 LLM 用量

在 Langfuse Dashboard 中：

| 功能 | 路徑 | 說明 |
|------|------|------|
| **Traces** | 左側選單 → Traces | 所有 API 請求的詳細記錄 |
| **Dashboard** | 左側選單 → Dashboard | 總覽統計圖表 |
| **Metrics** | 左側選單 → Metrics | 詳細用量指標 |

### 可查看的數據

- 請求數量（按模型分類）
- Token 使用量（輸入/輸出）
- 成本估算
- 延遲時間
- 錯誤率

### 篩選功能

在 Traces 頁面可按以下條件篩選：
- 模型名稱（如 `gemini-2.5-flash`）
- 時間範圍
- 用戶 ID
- 狀態（成功/失敗）

---

## 管理 API Tokens

### 創建新的 Virtual Key

```bash
curl -X POST https://YOUR-LITELLM-URL.zeabur.app/key/generate \
  -H "Authorization: Bearer sk-142f53c886806303b3a53d5a2a796599" \
  -H "Content-Type: application/json" \
  -d '{
    "duration": "30d",
    "models": ["gemini-2.5-flash", "gemini-3-pro"],
    "max_budget": 100,
    "user_id": "user-123"
  }'
```

### 列出所有 Keys

```bash
curl https://YOUR-LITELLM-URL.zeabur.app/key/info \
  -H "Authorization: Bearer sk-142f53c886806303b3a53d5a2a796599"
```

### 刪除 Key

```bash
curl -X POST https://YOUR-LITELLM-URL.zeabur.app/key/delete \
  -H "Authorization: Bearer sk-142f53c886806303b3a53d5a2a796599" \
  -H "Content-Type: application/json" \
  -d '{"keys": ["sk-要刪除的key"]}'
```

### Key 功能參數

| 參數 | 說明 |
|------|------|
| `models` | 限制可使用的模型列表 |
| `max_budget` | 預算上限（美元） |
| `duration` | 有效期限（如 `30d`、`1y`） |
| `user_id` | 關聯用戶（在 Langfuse 中追蹤） |
| `team_id` | 關聯團隊 |

---

## 故障排除

### "Can't reach database server"

1. 確認 PostgreSQL 服務正在運行
2. 確認 `DATABASE_URL` 完整且正確
3. 重新部署 Langfuse

### NEXTAUTH_URL 錯誤

1. 確認 `NEXTAUTH_URL` 與實際服務 URL 完全一致
2. 包含 `https://`
3. 重新部署

### LiteLLM 無法連接 Langfuse

1. 確認 `LANGFUSE_HOST` 是正確的 Langfuse URL
2. 確認 API Keys 正確
3. 重新部署 LiteLLM Proxy

### Langfuse 沒有數據

1. 確認 LiteLLM Proxy 正常運行
2. 發送測試請求
3. 等待幾秒鐘後刷新 Langfuse

---

## 快速檢查清單

- [ ] PostgreSQL 部署並運行
- [ ] Langfuse 部署完成
- [ ] `DATABASE_URL` 設置正確
- [ ] `NEXTAUTH_URL` 更新為實際 URL
- [ ] Langfuse 帳號創建完成
- [ ] Langfuse API Keys 獲取
- [ ] LiteLLM Proxy 部署完成
- [ ] 所有環境變數設置正確
- [ ] 測試請求成功
- [ ] Langfuse Dashboard 顯示數據

