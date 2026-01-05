# 📊 Gemini Usage Dashboard

一個簡單的 Web Dashboard，用於查看 Gemini 模型的使用情況。

## 功能

- 📈 顯示所有 Gemini 模型的用量統計
- 💰 成本追蹤
- 📊 Token 使用量
- ⏱️ 延遲統計
- 🔄 自動刷新（每 30 秒）

## 快速開始

### 本地運行

1. 安裝依賴：
```bash
cd dashboard
pip install -r requirements.txt
```

2. 設置環境變數：
```bash
export LANGFUSE_PUBLIC_KEY=your-public-key
export LANGFUSE_SECRET_KEY=your-secret-key
export LANGFUSE_HOST=https://cloud.langfuse.com  # 可選
export PORT=5000  # 可選，默認 5000
```

3. 運行：
```bash
python app.py
```

4. 打開瀏覽器：
```
http://localhost:5000
```

### Docker 部署

1. 構建映像：
```bash
cd dashboard
docker build -t gemini-dashboard .
```

2. 運行容器：
```bash
docker run -d \
  -p 5000:5000 \
  -e LANGFUSE_PUBLIC_KEY=your-key \
  -e LANGFUSE_SECRET_KEY=your-secret \
  -e LANGFUSE_HOST=https://cloud.langfuse.com \
  --name gemini-dashboard \
  gemini-dashboard
```

### Zeabur 部署

1. 在 Zeabur 上創建新服務
2. 連接這個 dashboard 目錄
3. 設置環境變數：
   - `LANGFUSE_PUBLIC_KEY`
   - `LANGFUSE_SECRET_KEY`
   - `LANGFUSE_HOST` (可選)

## 環境變數

| 變數 | 說明 | 必填 |
|------|------|------|
| `LANGFUSE_PUBLIC_KEY` | Langfuse 公鑰 | ✅ |
| `LANGFUSE_SECRET_KEY` | Langfuse 私鑰 | ✅ |
| `LANGFUSE_HOST` | Langfuse 服務地址 | ❌ |
| `PORT` | Dashboard 端口 | ❌ |

## 顯示的模型

Dashboard 會顯示以下 Gemini 模型的用量：

- Gemini 3 Pro
- Gemini 3 Flash
- Gemini 3 Deep Think
- Gemini 2.5 Pro
- Gemini 2.5 Flash
- Gemini 2.5 Flash Lite
- Gemini 3 Pro Image
- Gemini Live 3 Flash

## API 端點

- `GET /` - Dashboard 主頁
- `GET /api/metrics` - 獲取所有模型的用量數據（JSON）
- `GET /api/models` - 獲取已啟用的模型列表（JSON）

