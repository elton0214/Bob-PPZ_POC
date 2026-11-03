# Bob + PPZ POC — 專案資料夾說明

本文件說明專案資料夾在 POC 前後的樣貌，以及各步驟卡（E–N）對檔案系統的影響。
規則依據：[`AGENTS.md`](AGENTS.md)、[`OP-MANUAL.md`](OP-MANUAL.md)。
參考來源與證據對照：[`RESOURCES.md`](RESOURCES.md)。CR 目錄範本目前僅供參考，暫無強制填寫要求。

## 階段概覽（核心原則）

- **預期客戶提供**：CR 需求變更單（email / Word）＋ 程式碼壓縮包（`.zip`）
- **現場操作流程**：Git 開新分支，執行 `OP-MANUAL_xxx.md`（僅 步驟卡 0.5 ＋ E – N）
    - 階段流程參考：[`OP-MANUAL.md`](OP-MANUAL.md) "1.1 端到端流程"。
- **預期交付**：可參考本文件「[二、After](#二after全部步驟卡-en-完成後的預期狀態)」交付物清單（`delivery-output/` 之 DL-00 至 DL-08）＋ 1 份 Word 報告（各步驟截圖存證）

## 一、Before（POC 開始前的狀態）

```
Bob-PPZ_POC/
├── AGENTS.md                      ← 已存在（POC 規則，不可被 /init 覆蓋）
├── README.md                      ← 本文件
├── OP-MANUAL.md
├── CR/
│   ├── CR-template.md
│   └── CR-template_sample1.md
├── client-discussion-doc/         ← 訪談／註冊／防火牆文件（PDF、PPTX）
├── POC-SOURCE/                    ← 空（等待客戶交付包解壓縮）
├── delivery-output/               ← 空（等待 DL-xx 交付物）
├── .bob/tmp/
└── .git/
```

> **版本控制建議**：收到客戶交付物時，建議由 `master` 建立本機專屬分支（如 `git checkout -b cr/ub-fee-change`），並於生成手冊與解壓縮後建立基準 Commit，以隔離通用範本。版控僅限本機，不可 push 至外部平台。

## 二、After（全部步驟卡 E–N 完成後的預期狀態）

```
Bob-PPZ_POC/
├── AGENTS.md                      ← 不變（步驟卡 F 的 /init 不可覆蓋）
├── README.md
├── OP-MANUAL.md                   ← 通用手冊模板
├── OP-MANUAL_UB_CR.md             ← 0.5 實例化手冊（收到 CR 單與 Zip 後由 Bob 填入參數生成）
├── CR/…
├── client-discussion-doc/…
│
├── UNION_BANK_POC.zip             ← 步驟 E：客戶交付壓縮包（放置後解壓）
│
├── POC-SOURCE/                    ← 步驟 E：解壓縮結果
│   ├── cobol/      (*.cbl, *.cob)   ← 步驟 L 修改 CHKRTN01.cbl
│   ├── copybook/   (*.cpy)          ← 步驟 L 修改 CHKFEE01.cpy
│   ├── jcl/        (*.jcl)
│   ├── proc/       (*.proc)
│   ├── other/      (選用：BMS、DBD/PSB、DCLGEN)
│   ├── MANIFEST.csv
│   └── README.txt
│
├── .bobz/                         ← 步驟 G 產生
│   ├── local-settings.json          ← databaseLocation 指向 SQLite 路徑
│   └── (SQLite 分析資料庫，例如 ScannerOutput_result.db，
│        或由 databaseLocation 指到鄰近資料夾)
│
├── bobz/
│   └── DD.json                    ← 步驟 H：工作字典（技能實際讀寫的來源）
│
├── IMPACT-ANALYSIS.md             ← 步驟 J 原始輸出（≤1000 行），歸檔為 DL-04
├── implementation-plan.md         ← 步驟 K 原始輸出（≤1000 行），歸檔為 DL-05
│
└── delivery-output/               ← 所有交付物集中處
    ├── DL-00-delivery-check.md           (E 交付完整性檢查報告，唯一存放位置)
    ├── DL-01-scan-summary.md             (G 掃描摘要／相依關係)
    ├── DL-02-data-dictionary.json        (H 由 bobz/DD.json 複製，僅供交付)
    ├── DL-03-CHKRTN01-explanation.md     (I 流程分析／業務規則)
    ├── DL-04-impact-analysis.md          (J 影響分析)
    ├── DL-05-implementation-plan.md      (K 實施計畫)
    ├── DL-06-review-record.md            (L Diff 與審查紀錄)
    ├── DL-07-test-results.md             (M 主機測試結果)
    └── DL-08-POC-review-report.md        (N 成果回顧，含 Precision／Recall)
```

> `DL-02-data-dictionary.json` 只是 `bobz/DD.json` 的複本，用 `Copy-Item -Path "bobz/DD.json" -Destination "delivery-output/DL-02-data-dictionary.json" -Force` 同步。
> 請勿直接編輯複本；步驟 L 新增欄位後須重新複製。

## 三、各步驟卡對檔案系統的影響

```mermaid
flowchart LR
    P0[0.5 手冊實例化] -->|填入參數| OP[OP-MANUAL_UB_CR.md]
    OP --> E[E 交付檢查]
    E -->|解壓縮 + 報告| P[POC-SOURCE/ + DL-00]
    F[F 試跑] -->|/init 不覆蓋| A[AGENTS.md 不變]
    G[G 掃描建庫] --> S[.bobz/local-settings.json + SQLite DB + DL-01]
    H[H 資料字典] --> D[bobz/DD.json → 複製為 DL-02]
    I[I 流程分析] --> D3[DL-03]
    J[J 影響分析] --> D4[DL-04]
    K[K 實施計畫] --> D5[DL-05]
    L[L 程式修改] --> M[修改 .cbl/.cpy + 更新 DD.json 並重新複製 + DL-06]
    M2[M 編譯測試] --> D7[DL-07]
    N[N 成果回顧] --> D8[DL-08]
```

| 步驟 | 新增 | 修改 |
|---|---|---|
| 0.5 | `OP-MANUAL_UB_CR.md`（專屬實例化手冊） | — |
| E | `POC-SOURCE/*`、`DL-00` | — |
| F | 無（只讀） | `AGENTS.md` 不可被覆蓋 |
| G | SQLite 資料庫、`DL-01` | `.bobz/local-settings.json` |
| H | `bobz/DD.json`、`DL-02`（複製） | — |
| I | `DL-03` | — |
| J | `DL-04`（原 `IMPACT-ANALYSIS.md`） | — |
| K | `DL-05`（原 `implementation-plan.md`） | — |
| L | `DL-06` | `CHKRTN01.cbl`、`CHKFEE01.cpy`、`bobz/DD.json`、`DL-02`（重新複製） |
| M | `DL-07` | — |
| N | `DL-08` | — |

## 四、文件維護規則（STE 精神）

本節供《OP-MANUAL.md》的維護者使用。現場人員不需閱讀。

本版依 ASD-STE100（Simplified Technical English）的精神，用中文改寫。規則如下：

| 規則 | 做法 |
|---|---|
| 一句一事 | 每個步驟只寫一個動作。 |
| 短句 | 步驟句不超過 25 字。說明句不超過 35 字。 |
| 主動語氣 | 用祈使句開頭：「開啟」「輸入」「確認」。不寫被動句。 |
| 一詞一義 | 同一個東西只用同一個詞（見 `OP-MANUAL.md` 0.3 用語表）。 |
| 警告在前 | 「警告」與「注意」放在相關步驟之前。 |
| 條件在前 | 先寫條件，再寫動作：「若……，則……」。 |
| 明確用詞 | 不用「適當」「必要時」「盡量」「視情況」。要寫出數字、名稱或條件。 |
| 步驟編號 | 一定要依順序做的動作用數字編號。 |
