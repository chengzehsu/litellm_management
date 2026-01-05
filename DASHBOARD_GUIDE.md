# 📊 Langfuse Dashboard 使用指南

## 查看 Gemini 模型用量的 Dashboard

### 1. 登入 Langfuse Dashboard

**Cloud 版本：**
- 前往：https://cloud.langfuse.com
- 使用你的帳號登入

**Self-hosted 版本：**
- 前往你的 Langfuse 實例 URL
- 使用你的帳號登入

### 2. 進入 Dashboard

登入後，你會看到 Langfuse 的主 Dashboard，包含：

#### 📈 Metrics 頁面（推薦查看用量）
- **位置**：左側選單 → "Metrics"
- **功能**：
  - 按模型分組的請求統計
  - Token 使用量（輸入/輸出）
  - 成本分析
  - 延遲時間統計
  - 錯誤率

#### 🔍 Traces 頁面（詳細請求記錄）
- **位置**：左側選單 → "Traces"
- **功能**：
  - 查看每個請求的詳細記錄
  - 篩選特定模型（例如：gemini-3-flash）
  - 查看輸入/輸出內容
  - 查看延遲和成本

### 3. 篩選 Gemini 模型

在 Metrics 或 Traces 頁面：

1. **使用篩選器**
   - 點擊「Model」或「模型」篩選器
   - 選擇你要查看的 Gemini 模型：
     - `gemini-3-pro`
     - `gemini-3-flash`
     - `gemini-3-deep-think`
     - `gemini-2.5-pro`
     - `gemini-2.5-flash`
     - `gemini-2.5-flash-lite`
     - `gemini-3-pro-image`
     - `gemini-live-3-flash`

2. **查看統計數據**
   - 請求次數
   - 總 Token 數
   - 總成本
   - 平均延遲
   - P50/P95 延遲

### 4. Dashboard 視圖說明

#### Metrics Dashboard 顯示：
- 📊 **請求趨勢圖**：顯示時間序列的請求量
- 💰 **成本分析**：按模型顯示總成本和平均成本
- ⏱️ **延遲分析**：顯示響應時間統計
- 📈 **Token 使用**：輸入和輸出 Token 的統計
- ❌ **錯誤率**：失敗請求的百分比

#### 時間範圍選擇：
- 可以選擇不同的時間範圍（1小時、24小時、7天、30天等）
- 查看不同時段的用量趨勢

### 5. 導出數據（可選）

如果需要導出數據進行進一步分析：
- 在 Metrics 或 Traces 頁面
- 點擊「Export」按鈕
- 選擇導出格式（CSV、JSON 等）

## 🎯 快速查看 Gemini 用量

**最快的方式：**

1. 登入 Langfuse → https://cloud.langfuse.com
2. 點擊左側「**Metrics**」
3. 在「Model」篩選器中選擇 Gemini 模型
4. 查看 Dashboard 上的統計數據

就是這麼簡單！所有通過 LiteLLM Proxy 的 Gemini 請求都會自動顯示在這裡。

## 📝 注意事項

- 確保 LiteLLM Proxy 已正確配置 Langfuse callback
- 確保 `LANGFUSE_PUBLIC_KEY` 和 `LANGFUSE_SECRET_KEY` 已設置
- 數據會實時更新，但可能有幾秒鐘的延遲

