       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHKRPT01.
      *================================================================*
      * PROGRAM  : CHKRPT01                                            *
      * PURPOSE  : RETURNED CHECK FEE REPORT (DAILY)                   *
      * DB2      : SELECT FROM CHK_RETURN_TXN                          *
      * OUTPUT   : RPTOUT (LRECL=80)                                   *
      *================================================================*
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT RPT-FILE ASSIGN TO RPTOUT
               ORGANIZATION IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD  RPT-FILE
           RECORDING MODE IS F
           RECORD CONTAINS 80 CHARACTERS.
       01  RPT-REC                     PIC X(80).
       WORKING-STORAGE SECTION.
           COPY CHKFEE01.
           COPY CHKRPTLN.
           EXEC SQL INCLUDE SQLCA END-EXEC.
           EXEC SQL INCLUDE CHKRTNDG END-EXEC.
           EXEC SQL DECLARE C1 CURSOR FOR
               SELECT CHECK_NO, ACCT_NO, CHECK_AMT, FEE_AMT
                 FROM CHK_RETURN_TXN
                WHERE RETURN_DATE = CURRENT DATE
                ORDER BY CHECK_NO
           END-EXEC.
       01  WS-TOTAL-FEE                PIC S9(09)V99 COMP-3 VALUE ZERO.
       01  WS-DONE                     PIC X(01) VALUE 'N'.
           88  WS-NO-MORE              VALUE 'Y'.
       PROCEDURE DIVISION.
       0000-MAIN.
           OPEN OUTPUT RPT-FILE
           PERFORM 1000-WRITE-HEADER
           EXEC SQL OPEN C1 END-EXEC
           PERFORM 2000-FETCH-LOOP UNTIL WS-NO-MORE
           EXEC SQL CLOSE C1 END-EXEC
           PERFORM 3000-WRITE-TOTAL
           CLOSE RPT-FILE
           GOBACK.
       1000-WRITE-HEADER.
           WRITE RPT-REC FROM RPT-HEADER-1
      *    PRINT THE CURRENT STANDARD FEE AS A NOTE UNDER THE HEADER
           MOVE CHK-FEE-STD-AMT TO RPT-STD-FEE
           WRITE RPT-REC FROM RPT-FEE-NOTE.
       2000-FETCH-LOOP.
           EXEC SQL FETCH C1
               INTO :CHECK-NO, :ACCT-NO, :CHECK-AMT, :FEE-AMT
           END-EXEC
           IF SQLCODE = 100
               SET WS-NO-MORE TO TRUE
           ELSE
               MOVE CHECK-NO  TO RPT-CHECK-NO
               MOVE ACCT-NO   TO RPT-ACCT-NO
               MOVE CHECK-AMT TO RPT-CHECK-AMT
               MOVE FEE-AMT   TO RPT-FEE-AMT
               ADD FEE-AMT    TO WS-TOTAL-FEE
               WRITE RPT-REC FROM RPT-DETAIL
           END-IF.
       3000-WRITE-TOTAL.
           MOVE WS-TOTAL-FEE TO RPT-TOTAL-FEE
           WRITE RPT-REC FROM RPT-TOTAL-LINE.
