POC-SOURCE README  (SAMPLE - 虛構示例資料)
==========================================
CR 編號        : CR-POC-2026-001
變更標題       : 支票存款－退票手續費計算規則調整
交付人         : 黃建宏 (資訊部)
交付日期       : 2026-11-13

[來源環境]
LPAR           : PRDA
PDS/PDSE       : PROD.CHK.SRC, PROD.CHK.COPYLIB, PROD.CHK.JCL, PROD.CHK.PROCLIB, PROD.CHK.DCLGEN
程式碼擷取日期 : 2026-10-15

[編譯與格式]
COBOL 編譯器版本 : Enterprise COBOL for z/OS 6.4
字元編碼         : 已由 CP937 轉換為 UTF-8
行格式           : 固定格式 (欄 7-72)
COPY 搜尋順序    : PROD.CHK.COPYLIB -> PROD.COMMON.COPYLIB
編譯選項         : LIB,APOST,RENT,OPT(1)

[脫敏說明]
已替換帳號、客戶姓名等測試值。JCL 內 DSN 已改為 TEST.* 測試資料集名稱。

[已知缺失 / 邊界]
- COPY CHKCOM09 : 共用 COPY，由另一部門維護，未能提供
- CHKXCH00      : 票據交換所介面，僅有載入模組，無原始碼
- CHKRTN01 以 WS-SUBPGM 動態呼叫 CHKLOG01 / CHKAUD01

[資料庫 / 檔案]
Db2 表 : CHK_RETURN_TXN (DCLGEN 見 other/CHKRTNDG.dclgen)
VSAM   : CHK.MASTER.KSDS

[壓縮檔]
AES-256 加密，密碼由另一渠道通知 (不記載於本檔)。
