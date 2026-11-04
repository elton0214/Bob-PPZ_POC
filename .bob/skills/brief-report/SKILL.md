---
name: brief-report
description: Use when the user explicitly asks to produce a human-friendly brief (_brief) version of an existing delivery-output report (DL-03 explanation, DL-04 impact analysis, DL-05 implementation plan, DL-06 review record, DL-07 test results). Keeps boundaries and unverified items intact and verifies counts against the original.
metadata:
  disable-model-invocation: true
  argument-hint: "[底稿路徑，例如 delivery-output/DL-04-impact-analysis.md]"
---

# 產生精簡版報告（_brief）

由已定稿的底稿，另存一份 human-friendly 精簡版。**底稿不可修改。** 一律使用繁體中文。

## 硬規則（任何報告類型都適用）

1. 精簡版只能縮短與重排，**不可新增底稿沒有的事實，不可改寫結論**。
2. 「邊界」與「尚未驗證」項目**逐項完整保留**，連同編號（如 B1、R1）。
3. 開頭必須有一行：`本檔不取代底稿`，並連結底稿。
4. 不可讀取 `sealed/`（已知答案文件只在步驟卡 N 讀取）。
5. 底稿若含疑似未脫敏個資（帳號、身分證號、卡號）→ 立即停止，通知 SEC，不產生精簡版。
6. 不可貼入 SYSOUT 原文。不 commit。

## 步驟

1. **確認輸入**：底稿路徑由使用者提供。缺少則用 `ask_followup_question` 詢問。
   - 必須是 `.md`，且檔名不含 `_brief`。
   - 輸出路徑 = 同資料夾，檔名為「底稿檔名去掉 `.md`，加 `_brief.md`」。
   - 精簡版已存在時，告知使用者將重新產生（只覆蓋 `_brief`，不碰底稿）。
2. **完整讀取底稿**（`read_file`，被截斷就分段讀完）。
3. **判斷類型，套用下表規則**。不符合下表的檔案，只套用通用規則並告知使用者「無專屬規則」。
4. **寫入前先計數**（兩次獨立計數，不一致就第三次，取多數）：
   - 所有類型：邊界／尚未驗證項目數。
   - DL-04：風險項數。DL-05：測試案例數、回退步驟數。DL-06：修改處數。DL-07：測試案例數、失敗數、尚未驗證數。
5. **寫入精簡版**（`write_file`）。結構：標題（原標題＋「（精簡版）」）→ 來源與「不取代底稿」→ 5 點以內重點摘要 → 依類型的內容 → 邊界與尚未驗證 → 下一步 → 檔尾「數量核對」。
6. **驗證**：重新讀取精簡版，對步驟 4 的每一項再計數，與底稿比對。
   - 有差異 → 補回缺漏項目後重新驗證。不可略過。
7. **回報**：精簡版路徑、各項數量（底稿 vs 精簡版）、刪掉了哪類內容。提醒尚未 commit。

## 依類型的規則

| 底稿 | 保留重點 | 可精簡 | 行數上限 |
|---|---|---|---|
| DL-03 流程分析 `*-explanation.md` | 業務規則與關鍵判斷的行號、欄位追蹤 | 流程圖只留一張主流程圖＋一張欄位流向圖；與本次變更無直接關係的觀察移到附錄 | 約 120 |
| DL-04 影響分析 `*-impact-analysis.md` | 風險表（ID、等級、處理方式）、受影響元件 | 受影響清單合併一張表並標示必改／條件式／只重編譯；只留一張欄位流向圖 | 約 150 |
| DL-05 實施計畫 `*-implementation-plan.md` | **測試案例（含邊界值）與回退計畫逐項完整保留，不可濃縮** | 執行順序、受影響元件各用一張表 | 約 150 |
| DL-06 審查紀錄 `*-review-record.md` | **每一處修改都列出**（檔名、位置、對應計畫項目、DEV 審閱結果）；超出計畫範圍的修改完整保留 | 描述縮短，每處加一句白話說明 | 約 100 |
| DL-07 測試結果 `*-test-results.md` | **每個案例列於一張表**（案例、輸入、預期、實際、結果）；失敗與尚未驗證逐項保留原因與後續處理 | 其餘敘述 | 約 100 |

DL-00、DL-01 本身是檢查表或摘要，DL-02 是 JSON，DL-08 是成果回顧。這些通常不需要精簡版，使用者仍要求時只套用通用規則。

## 精簡版開頭範本

```markdown
# <原標題>（精簡版）

- 底稿：[<底稿檔名>](<底稿檔名>)。**本檔不取代底稿**；核准、審查與追溯以底稿為準。
```

DL-06 的說明改為「審查以底稿與 IDE Diff 為準」。
