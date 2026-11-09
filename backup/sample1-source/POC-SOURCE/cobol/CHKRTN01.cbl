       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHKRTN01.
      *================================================================*
      * PROGRAM  : CHKRTN01                                            *
      * PURPOSE  : RETURNED CHECK PROCESSING - CHARGE RETURN FEE,      *
      *            POST TRANSACTION TO DB2, LOG AND AUDIT.             *
      * INPUT    : RTNIN  (RETURNED CHECK FILE, SEE CHKRTNRC)          *
      * I/O      : MASTER (VSAM KSDS CHK.MASTER.KSDS)                  *
      * DB2      : INSERT INTO CHK_RETURN_TXN                          *
      *================================================================*
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT RTNIN-FILE  ASSIGN TO RTNIN
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-RTNIN-STATUS.
           SELECT MASTER-FILE ASSIGN TO MASTER
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS MST-ACCT-NO
               FILE STATUS IS WS-MASTER-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  RTNIN-FILE
           RECORDING MODE IS F
           RECORD CONTAINS 80 CHARACTERS.
           COPY CHKRTNRC.
       FD  MASTER-FILE.
           COPY CHKMSTRC.
       WORKING-STORAGE SECTION.
           COPY CHKFEE01.
           COPY CHKERRCD.
           COPY CHKCOM09.
           EXEC SQL INCLUDE SQLCA END-EXEC.
           EXEC SQL INCLUDE CHKRTNDG END-EXEC.
       01  WS-RTNIN-STATUS             PIC X(02).
       01  WS-MASTER-STATUS            PIC X(02).
       01  WS-EOF-FLAG                 PIC X(01) VALUE 'N'.
           88  WS-EOF                  VALUE 'Y'.
       01  WS-VALID-FLAG               PIC X(01).
           88  WS-VALID                VALUE 'Y'.
       01  WS-FEE-AMT                  PIC S9(07)V99 COMP-3.
       01  WS-SUBPGM                   PIC X(08).
       01  WS-LOG-AREA.
           05  WS-LOG-CHECK-NO         PIC X(10).
           05  WS-LOG-FEE              PIC S9(07)V99 COMP-3.
       01  WS-CNT-READ                 PIC 9(07) VALUE ZERO.
       01  WS-CNT-POSTED               PIC 9(07) VALUE ZERO.
       01  WS-CNT-REJECT               PIC 9(07) VALUE ZERO.
       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 2000-PROCESS UNTIL WS-EOF
           PERFORM 9000-TERMINATE
           GOBACK.
       1000-INIT.
           OPEN INPUT RTNIN-FILE
           OPEN I-O   MASTER-FILE
           READ RTNIN-FILE
               AT END SET WS-EOF TO TRUE
           END-READ.
       2000-PROCESS.
           ADD 1 TO WS-CNT-READ
           PERFORM 2100-VALIDATE
           IF WS-VALID
               PERFORM 2200-CALC-FEE
               PERFORM 2300-INSERT-TXN
               PERFORM 2400-CALL-SUBPGMS
               ADD 1 TO WS-CNT-POSTED
           ELSE
               ADD 1 TO WS-CNT-REJECT
           END-IF
           READ RTNIN-FILE
               AT END SET WS-EOF TO TRUE
           END-READ.
       2100-VALIDATE.
           MOVE 'Y' TO WS-VALID-FLAG
           IF NOT (RTN-NSF OR RTN-SIGN-MISMATCH OR RTN-ACCT-CLOSED)
               MOVE 'N' TO WS-VALID-FLAG
           END-IF
           MOVE RTN-ACCT-NO TO MST-ACCT-NO
           READ MASTER-FILE
               INVALID KEY MOVE 'N' TO WS-VALID-FLAG
           END-READ.
       2200-CALC-FEE.
      *    RETURN FEE IS A FLAT AMOUNT REGARDLESS OF CHECK AMOUNT
           IF CHK-FEE-WAIVED
               MOVE ZERO TO WS-FEE-AMT
           ELSE
               MOVE CHK-FEE-STD-AMT TO WS-FEE-AMT
           END-IF.
       2300-INSERT-TXN.
           MOVE RTN-CHECK-NO   TO CHECK-NO
           MOVE RTN-ACCT-NO    TO ACCT-NO
           MOVE RTN-CHECK-AMT  TO CHECK-AMT
           MOVE WS-FEE-AMT     TO FEE-AMT
           MOVE RTN-REASON-CODE TO REASON-CODE
           MOVE 'N'            TO POST-FLAG
           EXEC SQL
               INSERT INTO CHK_RETURN_TXN
                   (CHECK_NO, ACCT_NO, CHECK_AMT, FEE_AMT,
                    RETURN_DATE, REASON_CODE, POST_FLAG)
               VALUES
                   (:CHECK-NO, :ACCT-NO, :CHECK-AMT, :FEE-AMT,
                    CURRENT DATE, :REASON-CODE, :POST-FLAG)
           END-EXEC
           IF SQLCODE NOT = 0
               DISPLAY 'DB2 INSERT FAILED ' ERR-DB2-FAIL
                       ' SQLCODE=' SQLCODE
               MOVE 16 TO RETURN-CODE
               GOBACK
           END-IF.
       2400-CALL-SUBPGMS.
           MOVE RTN-CHECK-NO TO WS-LOG-CHECK-NO
           MOVE WS-FEE-AMT   TO WS-LOG-FEE
           MOVE 'CHKLOG01'   TO WS-SUBPGM
           CALL WS-SUBPGM USING WS-LOG-AREA
           MOVE 'CHKAUD01'   TO WS-SUBPGM
           CALL WS-SUBPGM USING WS-LOG-AREA
           CALL 'CHKXCH00' USING RTN-CHECK-NO.
       9000-TERMINATE.
           CLOSE RTNIN-FILE
           CLOSE MASTER-FILE
           DISPLAY 'CHKRTN01 READ=' WS-CNT-READ
                   ' POSTED=' WS-CNT-POSTED
                   ' REJECT=' WS-CNT-REJECT.
