# 🔗 前端連結指南

## 可用的前端 Dashboard

### 1. Langfuse Dashboard（主要 Dashboard）⭐

這是主要的 observability dashboard，用於查看所有 Gemini 模型的用量。

#### 如果使用 Langfuse Cloud：
- **URL**: https://cloud.langfuse.com
- **登入**: 使用你的 Langfuse 帳號

#### 如果使用 Self-Hosted Langfuse：

**本地部署：**
- **URL**: http://localhost:3000
- 啟動後直接訪問

**Zeabur 部署：**
1. 前往 Zeabur Dashboard: https://zeabur.com
2. 找到 Langfuse 服務
3. 點擊服務，查看 **服務 URL**
4. URL 格式：`https://langfuse-xxxxx.zeabur.app`

**查看方式：**
```bash
# 在 Zeabur Dashboard 中
1. 進入你的專案
2. 找到 Langfuse 服務
3. 點擊服務卡片
4. 在服務詳情頁面會顯示 "Service URL" 或 "Domain"
```

### 2. 簡單 Dashboard（可選）

如果你部署了 `dashboard/` 目錄的 Dashboard：

**本地運行：**
- **URL**: http://localhost:5000
- 運行 `python dashboard/app.py` 後訪問

**Zeabur 部署：**
1. 在 Zeabur 上部署 `dashboard` 目錄
2. 設置 Root Directory 為 `dashboard`
3. 獲取服務 URL（格式：`https://dashboard-xxxxx.zeabur.app`）

## 如何獲取 Zeabur 服務 URL

### 方法 1: Zeabur Dashboard

1. 登入 https://zeabur.com
2. 進入你的專案
3. 找到對應的服務（Langfuse 或 Dashboard）
4. 點擊服務卡片
5. 在服務詳情頁面會顯示：
   - **Service URL** 或
   - **Domain** 或
   - **訪問地址**

### 方法 2: Zeabur CLI

```bash
zeabur service list
zeabur service get <service-id>
```

### 方法 3: 檢查部署日誌

在 Zeabur 服務的日誌中，通常會顯示服務啟動後的 URL。

## 快速檢查清單

### Langfuse Dashboard

- [ ] Langfuse 服務已部署
- [ ] 獲取了 Langfuse URL
- [ ] 可以訪問 Langfuse Web UI
- [ ] 已創建帳號並登入
- [ ] 可以看到 Traces 頁面

### 簡單 Dashboard（如果部署）

- [ ] Dashboard 服務已部署
- [ ] 獲取了 Dashboard URL
- [ ] 可以訪問 Dashboard
- [ ] 可以看到 Gemini 模型統計

## 使用 Langfuse Dashboard 查看 Gemini 用量

### 步驟：

1. **訪問 Langfuse URL**
   - Cloud: https://cloud.langfuse.com
   - Self-hosted: 你的 Zeabur URL 或 localhost:3000

2. **登入**
   - 首次訪問會提示創建帳號
   - 使用你的 email 註冊

3. **查看 Traces**
   - 點擊左側選單「**Traces**」
   - 所有通過 LiteLLM Proxy 的請求都會顯示在這裡

4. **查看 Metrics**
   - 點擊左側選單「**Metrics**」
   - 查看按模型分組的統計數據：
     - 請求次數
     - Token 使用量
     - 成本
     - 延遲時間

5. **篩選 Gemini 模型**
   - 在 Traces 或 Metrics 頁面
   - 使用「Model」篩選器
   - 選擇你要查看的 Gemini 模型：
     - gemini-3-pro
     - gemini-3-flash
     - gemini-3-deep-think
     - gemini-2.5-pro
     - gemini-2.5-flash
     - gemini-2.5-flash-lite
     - gemini-3-pro-image
     - gemini-live-3-flash

## 常見問題

### Q: 找不到服務 URL？

A: 
1. 確認服務已成功部署（狀態顯示「運行中」）
2. 檢查服務設置中是否有自定義域名
3. 查看 Zeabur 服務日誌

### Q: 無法訪問 Langfuse？

A:
1. 確認 Langfuse 服務正在運行
2. 檢查環境變數是否正確（特別是 `NEXTAUTH_URL`）
3. 確認端口設置正確（默認 3000）

### Q: Dashboard 顯示無數據？

A:
1. 確認 LiteLLM Proxy 已正確配置 Langfuse callback
2. 確認 `LANGFUSE_PUBLIC_KEY` 和 `LANGFUSE_SECRET_KEY` 正確
3. 發送一些測試請求到 LiteLLM Proxy
4. 等待幾秒鐘讓數據同步

## 快速命令

### 檢查服務狀態（Zeabur CLI）

```bash
# 列出所有服務
zeabur service list

# 獲取服務詳情（包含 URL）
zeabur service get <service-id>
```

### 測試 Langfuse 連接

```bash
# 替換成你的 Langfuse URL
curl https://your-langfuse-url.zeabur.app/api/public/health
```

## 推薦設置

**主要使用 Langfuse Dashboard**，因為它提供：
- ✅ 完整的 observability 功能
- ✅ 詳細的 traces 和 metrics
- ✅ 成本追蹤
- ✅ 錯誤分析
- ✅ 數據導出功能

簡單 Dashboard 可以作為補充，但 Langfuse 是主要的前端界面。

