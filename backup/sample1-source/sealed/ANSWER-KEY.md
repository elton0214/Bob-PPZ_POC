# 已知答案（密封文件）— SAMPLE

> ⚠️ 依 AGENTS.md：本檔 **只可在步驟卡 N（成果回顧）才可讀取**。
> 在步驟卡 J（影響分析）／K（實施計畫）之前不可提供給 Bob。
> 本檔與 `POC-SOURCE/` 分開存放，不應放在 Bob 的工作區內。

| 類別 | 程式／檔案 | 說明 |
|---|---|---|
| 必須修改 | `CHKRTN01.cbl` | `2200-CALC-FEE` 改為依面額分級（≤100,000 收 150；>100,000 收 300） |
| 必須修改 | `CHKFEE01.cpy` | 新增 `CHK-FEE-HIGH-AMT`（300）與 `CHK-FEE-THRESHOLD`（100,000） |
| 受影響（上下游） | `CHKRPT01.cbl` | 報表表頭只印單一標準費率，需調整為顯示兩級費率 |
| 受影響（上下游） | `CHKEOD01.jcl` | 日終批次；JCL 本身不改，但需於測試時重跑驗證合計 |
| 不應被列入 | `CHKWAV01.cbl` | 豁免維護，雖引用 `CHKFEE01`，但不在本次範圍（誘答項） |
| 不應被列入 | `CHKLOG01` / `CHKAUD01` | 動態呼叫目標，不涉及費率計算（誘答項） |

**Precision／Recall 計算基準**
- 應找（Recall 分母）：`CHKRTN01`、`CHKFEE01`、`CHKRPT01`、`CHKEOD01` = 4 項
- 誘答項：`CHKWAV01`（引用 `CHKFEE01` 但無需修改）
