# GitHub Actions Workflows

這個目錄包含專案的 CI/CD 工作流程。

## deploy.yml

主要的部署工作流程，在每次推送到 `main` 或 `master` 分支時執行。

### 工作流程步驟

1. **Validate** - 驗證配置文件
   - 檢查 `config.yaml` 格式和必要配置
   - 驗證所有必要文件存在
   - 檢查 Dockerfile 和 requirements.txt

2. **Test Build** - 測試 Docker 構建
   - 構建 Docker 映像
   - 驗證構建成功

3. **Lint** - 代碼檢查
   - YAML 文件檢查
   - Shell 腳本語法檢查

4. **Security** - 安全檢查
   - 檢查是否有 secrets 洩露
   - 確認 .env 文件未被提交

5. **Notify** - 部署通知
   - 所有檢查通過後通知
   - Zeabur 會自動部署

### 觸發條件

- 推送到 `main` 或 `master` 分支
- 創建 Pull Request 到 `main` 或 `master` 分支
- 修改相關文件（.py, .yaml, Dockerfile, requirements.txt 等）

### Zeabur 自動部署

當工作流程通過後，Zeabur 會自動檢測變更並部署。確保：

1. 在 Zeabur 中已連接 GitHub repository
2. 已啟用自動部署功能
3. 環境變數已在 Zeabur 中正確設置

