# 🚀 立即部署指南

## ✅ 當前狀態

- ✅ 代碼已推送到 GitHub: https://github.com/chengzehsu/litellm_management
- ✅ GitHub Actions 正在驗證（應該很快就完成）
- ✅ 所有 Gemini 模型已配置完成

## 📋 Zeabur 部署步驟

### 步驟 1: 登入 Zeabur

1. 前往 https://zeabur.com
2. 使用 GitHub 帳號登入（推薦，自動連接 repository）

### 步驟 2: 導入專案

**如果還沒有部署過：**

1. 點擊「**新增服務**」或「**Add Service**」
2. 選擇「**從 GitHub 導入**」或「**Import from GitHub**」
3. 搜尋：`litellm_management`
4. 選擇：`chengzehsu/litellm_management`
5. Zeabur 會自動檢測 Dockerfile ✅

**如果已經部署過：**

1. 進入你的專案
2. 找到 `litellm_management` 服務
3. Zeabur 應該會自動檢測到新的 commit 並重新部署
4. 如果沒有自動部署，點擊「**重新部署**」或「**Redeploy**」

### 步驟 3: 設置環境變數（重要！）

在服務設置的「**環境變數**」或「**Environment Variables**」中，確保以下變數都已設置：

#### 必填環境變數

```bash
LITELLM_MASTER_KEY=你的master-key（例如：sk-1234）
DATABASE_URL=你的資料庫連接字串
LANGFUSE_PUBLIC_KEY=你的Langfuse公鑰（pk-開頭）
LANGFUSE_SECRET_KEY=你的Langfuse私鑰（sk-開頭）
DISABLE_ADMIN_UI=True
```

#### Gemini 模型所需

```bash
GOOGLE_API_KEY=你的google-api-key
```

**獲取 Google API Key：**
1. 前往 https://aistudio.google.com/app/apikey
2. 登入 Google 帳號
3. 創建新的 API Key
4. 複製並添加到 Zeabur 環境變數

### 步驟 4: 確認部署

1. 等待構建完成（通常 2-5 分鐘）
2. 查看服務狀態，應該顯示「**運行中**」或「**Running**」
3. 檢查日誌確認沒有錯誤

### 步驟 5: 測試服務

在 Zeabur Dashboard 中，你會看到服務的 URL（例如：`https://litellm-xxxxx.zeabur.app`）

```bash
# 健康檢查
curl https://your-service.zeabur.app/healthz

# 測試 Gemini 模型
curl https://your-service.zeabur.app/v1/chat/completions \
  -H "Authorization: Bearer YOUR_LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-3-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## 🔍 驗證部署

### 檢查 GitHub Actions

訪問：https://github.com/chengzehsu/litellm_management/actions

確認：
- ✅ 所有工作流程通過（綠色 ✓）
- ✅ 沒有錯誤或警告

### 檢查 Zeabur 部署

1. 在 Zeabur Dashboard 查看服務狀態
2. 點擊服務查看日誌
3. 確認沒有錯誤訊息

### 檢查 Langfuse

1. 登入 Langfuse: https://cloud.langfuse.com
2. 前往你的專案
3. 發送測試請求後，應該能在「Traces」頁面看到記錄

## 📊 已配置的 Gemini 模型

部署完成後，以下模型都可以使用：

**Gemini 3 系列：**
- `gemini-3-pro` - 進階推理
- `gemini-3-flash` - 預設模型，極速反應
- `gemini-3-deep-think` - 強化邏輯推導

**Gemini 2.5 系列：**
- `gemini-2.5-pro` - 長上下文穩定版
- `gemini-2.5-flash` - 高性價比
- `gemini-2.5-flash-lite` - 極低延遲

**特殊用途：**
- `gemini-3-pro-image` - 影像生成與分析
- `gemini-live-3-flash` - 即時語音對話

## 🆘 故障排除

### 部署失敗

1. 檢查 Zeabur 日誌
2. 確認所有必填環境變數已設置
3. 確認 `GOOGLE_API_KEY` 正確

### 服務無法啟動

1. 檢查環境變數是否完整
2. 確認資料庫連接正常
3. 查看 Zeabur 日誌了解錯誤

### 模型請求失敗

1. 確認 `GOOGLE_API_KEY` 有效
2. 檢查模型名稱是否正確
3. 查看 LiteLLM 日誌

## 🔗 重要連結

- **GitHub Repository**: https://github.com/chengzehsu/litellm_management
- **GitHub Actions**: https://github.com/chengzehsu/litellm_management/actions
- **Zeabur Dashboard**: https://zeabur.com
- **Langfuse**: https://cloud.langfuse.com
- **Google AI Studio**: https://aistudio.google.com/app/apikey

