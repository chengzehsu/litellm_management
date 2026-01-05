# ⚡ 快速開始指南

## 🎯 當前狀態

✅ **GitHub Repository**: https://github.com/chengzehsu/litellm_management  
✅ **代碼已推送**: 所有文件已上傳  
✅ **CI/CD 已配置**: GitHub Actions 工作流程已設置  

## 🚀 5 分鐘完成 Zeabur 部署

### 步驟 1: 登入 Zeabur（30 秒）

1. 前往 https://zeabur.com
2. 使用 GitHub 帳號登入（推薦，自動連接 repository）

### 步驟 2: 導入專案（1 分鐘）

1. 點擊「**新增服務**」或「**Add Service**」
2. 選擇「**從 GitHub 導入**」或「**Import from GitHub**」
3. 搜尋：`litellm_management`
4. 選擇：`chengzehsu/litellm_management`
5. Zeabur 會自動檢測 Dockerfile ✅

### 步驟 3: 設置環境變數（2 分鐘）

在服務設置的「**環境變數**」或「**Environment Variables**」中添加：

#### 複製以下變數名稱，然後填入你的實際值：

```
LITELLM_MASTER_KEY=你的master-key（例如：sk-1234）
DATABASE_URL=你的資料庫連接字串
LANGFUSE_PUBLIC_KEY=你的Langfuse公鑰（pk-開頭）
LANGFUSE_SECRET_KEY=你的Langfuse私鑰（sk-開頭）
DISABLE_ADMIN_UI=True
```

**如何獲取 Langfuse Keys？**
1. 前往 https://cloud.langfuse.com
2. 登入並創建專案
3. 進入專案設置 → API Keys
4. 創建新的 API Key，複製 Public Key 和 Secret Key

### 步驟 4: 啟用自動部署（30 秒）

1. 在服務設置中找到「**自動部署**」或「**Auto Deploy**」
2. 啟用它 ✅
3. 選擇分支：`main`

### 步驟 5: 部署（1 分鐘）

1. 點擊「**部署**」或「**Deploy**」按鈕
2. 等待構建完成（通常 2-5 分鐘）
3. 完成！🎉

## ✅ 驗證部署

### 檢查 GitHub Actions

訪問：https://github.com/chengzehsu/litellm_management/actions

應該看到：
- ✅ Validate Configuration - 通過
- ✅ Test Docker Build - 通過
- ✅ Code Linting - 通過
- ✅ Security Checks - 通過

### 檢查 Zeabur 服務

1. 在 Zeabur Dashboard 查看服務狀態
2. 應該顯示「**運行中**」或「**Running**」
3. 點擊服務查看日誌，確認沒有錯誤

### 測試 API

在 Zeabur Dashboard 中，你會看到服務的 URL（例如：`https://litellm-xxxxx.zeabur.app`）

```bash
# 替換成你的實際 URL
curl https://your-service.zeabur.app/health
```

## 🎊 完成！

現在你的 LiteLLM Proxy 已經運行，並且：
- ✅ 自動處理 LLM 請求
- ✅ 自動將 traces 發送到 Langfuse
- ✅ 每次推送代碼都會自動重新部署

## 📚 更多資訊

- 完整文檔：查看 `README.md`
- 部署狀態：查看 `DEPLOYMENT_STATUS.md`
- GitHub Actions：https://github.com/chengzehsu/litellm_management/actions

## 🆘 需要幫助？

如果遇到問題：
1. 檢查 `DEPLOYMENT_STATUS.md` 中的故障排除章節
2. 查看 Zeabur 部署日誌
3. 檢查 GitHub Actions 工作流程日誌

