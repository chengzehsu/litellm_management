# 🔧 Zeabur 數據庫連接問題修復

## 問題

錯誤訊息：
```
Can't reach database server at `service-695b33b5a87d9ee2983d59eb`:`5432`
```

## 原因

在 Zeabur 上，docker-compose 中的服務名稱（如 `postgres`、`clickhouse`）無法被正確解析。Zeabur 使用服務 ID 進行服務發現。

## 解決方案

### 方法 1: 使用環境變數覆蓋（推薦）

在 Zeabur 的 Langfuse 服務環境變數中，直接設置完整的連接字串：

#### 1. 獲取 PostgreSQL 服務信息

在 Zeabur Dashboard 中：
1. 找到 PostgreSQL 服務（通常是 `postgres` 服務）
2. 查看服務詳情，獲取：
   - 服務 ID（例如：`service-695b33b5a87d9ee2983d59eb`）
   - 端口（通常是 `5432`）

#### 2. 設置 DATABASE_URL

在 Langfuse 服務的環境變數中添加：

```
DATABASE_URL=postgresql://langfuse:你的密碼@service-695b33b5a87d9ee2983d59eb:5432/langfuse
```

**格式說明：**
```
postgresql://[用戶名]:[密碼]@[服務ID]:[端口]/[數據庫名]
```

#### 3. 設置 CLICKHOUSE_URL

同樣，找到 ClickHouse 服務的服務 ID，然後設置：

```
CLICKHOUSE_URL=http://langfuse:你的密碼@service-clickhouse-id:8123/langfuse
```

**格式說明：**
```
http://[用戶名]:[密碼]@[服務ID]:[端口]/[數據庫名]
```

### 方法 2: 使用 Zeabur 的內部 DNS

如果 Zeabur 支持內部 DNS，可以嘗試使用服務名稱：

```
DATABASE_URL=postgresql://langfuse:密碼@postgres:5432/langfuse
CLICKHOUSE_URL=http://langfuse:密碼@clickhouse:8123/langfuse
```

### 方法 3: 分開部署服務（最穩定）

將 PostgreSQL、ClickHouse 和 Langfuse 作為獨立的 Zeabur 服務部署：

1. **部署 PostgreSQL**：
   - 使用 Zeabur 的 PostgreSQL 模板
   - 或創建單獨的 PostgreSQL 服務

2. **部署 ClickHouse**：
   - 創建單獨的 ClickHouse 服務

3. **部署 Langfuse**：
   - 使用更新後的配置
   - 在環境變數中使用其他服務的 URL

## 快速修復步驟

### 在 Zeabur Dashboard 中：

1. **找到 Langfuse 服務**
2. **進入服務設置** → **環境變數**
3. **添加/更新以下變數**：

```
# 替換成實際的服務 ID 和密碼
DATABASE_URL=postgresql://langfuse:你的POSTGRES_PASSWORD@service-695b33b5a87d9ee2983d59eb:5432/langfuse

# 替換成 ClickHouse 服務 ID
CLICKHOUSE_URL=http://langfuse:你的CLICKHOUSE_PASSWORD@service-clickhouse-id:8123/langfuse
```

4. **保存並重新部署**

## 如何獲取服務 ID

### 方法 1: Zeabur Dashboard

1. 進入專案
2. 找到對應的服務（PostgreSQL、ClickHouse）
3. 點擊服務
4. 在 URL 或服務詳情中可以看到服務 ID
5. 格式通常是：`service-xxxxx`

### 方法 2: Zeabur CLI

```bash
zeabur service list
# 會顯示所有服務及其 ID
```

## 驗證修復

部署後，檢查 Langfuse 日誌：

1. 在 Zeabur Dashboard 中查看 Langfuse 服務日誌
2. 確認沒有數據庫連接錯誤
3. 訪問 Langfuse Web UI，應該可以正常訪問

## 完整環境變數示例

在 Zeabur 的 Langfuse 服務中設置：

```
# 數據庫連接（使用服務 ID）
DATABASE_URL=postgresql://langfuse:your-password@service-postgres-id:5432/langfuse
CLICKHOUSE_URL=http://langfuse:your-password@service-clickhouse-id:8123/langfuse

# 其他配置
POSTGRES_USER=langfuse
POSTGRES_PASSWORD=your-password
POSTGRES_DB=langfuse
CLICKHOUSE_DB=langfuse
CLICKHOUSE_USER=langfuse
CLICKHOUSE_PASSWORD=your-password
NEXTAUTH_SECRET=your-secret
NEXTAUTH_URL=https://langfuse-xxxxx.zeabur.app
SALT=your-salt
TELEMETRY_ENABLED=false
```

## 注意事項

1. **服務 ID 可能會變化**：如果重新部署服務，服務 ID 可能會改變
2. **使用環境變數**：優先使用 `DATABASE_URL` 和 `CLICKHOUSE_URL` 環境變數
3. **檢查日誌**：如果仍有問題，查看服務日誌了解詳細錯誤

## 如果問題持續

1. 確認 PostgreSQL 和 ClickHouse 服務正在運行
2. 確認服務 ID 正確
3. 確認密碼正確
4. 檢查 Zeabur 的網路設置
5. 考慮使用 Zeabur 的內建數據庫服務（如果可用）

