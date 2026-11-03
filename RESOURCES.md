# Bob + PPZ POC Resources

## Knowledge

### IBM 官方文件

- [Using tools and tool groups](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/Using_tools)
  PPZ 全部工具名稱與所屬群組。Use for: 確認 `scan_program`、`get_variables`、`execute_sql_query`、`zopeneditor-*` 等工具是否存在；`zopeneditor-*` 只在 Z Architect。
- [Using commands](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/Using_commands)
  斜線指令清單。Use for: `/init`、`/data-dictionary-management`、`/impact-analysis`、`/implementation-planning`；`/explain` 在 3.0.20+ 不支援。
- [Using skills](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/Using_skills)
  技能與對應模式。Use for: 影響分析與實施計畫屬 Z Architect。
- [Workflows](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/workflows)
  工作流程與所屬模式。Use for: Explain code、Program documentation、Business rules、Data dictionary 屬 Z Code；Application documentation 屬 Z Architect。
- [Prerequisites](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/prerequisites)
  環境需求。Use for: Bob IDE 2.3.0+、Z Open Editor 6.9.0+、Zowe Explorer 3.6.0+。
- [Getting started](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/getting-started)／[Modes](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/modes)／[Troubleshooting](https://bob.ibm.com/docs/ide/premium-packages/bob-for-z/troubleshooting)
  `/init` 流程、兩種模式用途、常見問題。Use for: 缺 Copybook、大型程式、批次產生資料字典上限。
- [Configuring firewall rules for Bob](https://bob.ibm.com/docs/ide/troubleshooting/ts-firewall-rules)
  防火牆網域清單。Use for: 8 個共同端點、`api.us-east.bob.ibm.com` 所有區域都要開、全部 HTTPS／TCP 443。
- [Configuring proxy settings](https://bob.ibm.com/docs/ide/troubleshooting/ts-proxy)
  Proxy 設定。Use for: `HTTP: Proxy Strict SSL` 預設啟用，不可隨意關閉。
- [Signing in](https://bob.ibm.com/docs/ide/account/signing-in)
  登入流程。Use for: IBMid 與 SSO 登入、登入失敗排查。
- [Installation](https://bob.ibm.com/docs/ide/getting-started/install)
  官方安裝需求。Use for: 官方最低 4 GB RAM（建議 8 GB）、500 MB 磁碟。

### 客戶與 IBM 團隊文件（本專案 `client-discussion-doc/`、`CR/`）

- [聯邦銀行 Bob PP4Z PoC 需求訪談會議](client-discussion-doc/20260917聯邦銀行_Bob_PP4Z_PoC_需求訪談會議.pdf)
  POC 目標與成功標準。Use for: D1／D2／D3 三項決策、五個階段、Precision／Recall 各 ≥80%（建議門檻）、不預先承諾節省比例。
- [聯邦銀行 PoC Local Workspace 訪談簡報 v3](client-discussion-doc/聯邦銀行_PoC_Local_Workspace_訪談簡報_v3.pptx)
  Local 模式修訂版。Use for: 不建中央 Z Understand、決策 2／3 為必要前提、D1 可由客戶代操作。
- [防火牆與 AP 開發機需求 20261007](client-discussion-doc/聯邦銀行_IBM_Bob_防火牆與AP開發機需求_20261007.pdf)
  IBM 團隊整理的網路與工作站建議。Use for: 16 GB／4 核心／20 GB 屬「規劃建議」，不是官方最低值。
- [IBMid 註冊操作指南](client-discussion-doc/UB_IBM_Bob_IBMid註冊操作指南.pdf)
  註冊步驟。Use for: 密碼 12–63 字元、7 位數驗證碼 30 分鐘失效、「您似乎沒有任何產品」屬正常。
- [變更需求單範例](CR/CR-sample1.md)
  變更需求單（CR-2026-CHK-008：退票手續費計算規則分級調整與手續費減免連動）。Use for: POC 變更分析與操作手冊實例化輸入。

## Wisdom (Communities)

- 尚無。使用者未指定社群。

## Gaps

- **Java 21+（64 位元）是否必要**：訪談簡報 v3 有列，官方 Prerequisites 沒列。手冊已標「待確認」。
- **`get_diagnostics` 工具**：步驟卡 L 提示詞使用，官方工具頁沒列。執行前先確認可用。
- **`.bobz/local-settings.json` 與 `databaseLocation`**：官方頁面都沒提。只出現在 `AGENTS.md`，視為專案假設。
- **「分析資料庫是 SQLite」**：官方只寫 metadata database。
- **DL 編號順序**：CR 範本是 DL-02 流程分析、DL-03 資料字典；本專案相反。需與客戶確認。
- **「結案後 14 天刪除」**：只在虛構範例出現。需填入客戶實際約定。
- **各步驟實際呼叫的工具**：官方只說 Bob 依需求自行選擇，手冊的「用自然語言觸發」是預期，須在預演時驗證。
- **Bob IDE 版本與 PPZ 版本的對應**：官方頁面分別標示版本，未說明對應關係。
