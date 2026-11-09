       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHKWAV01.
      *================================================================*
      * PROGRAM  : CHKWAV01                                            *
      * PURPOSE  : FEE WAIVER MAINTENANCE (OUT OF SCOPE FOR CR)        *
      *            SETS THE WAIVE FLAG FOR A GIVEN PROMOTION RUN.      *
      *================================================================*
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY CHKFEE01.
       01  WS-PROMO-FLAG               PIC X(01) VALUE 'N'.
       PROCEDURE DIVISION.
       0000-MAIN.
           IF WS-PROMO-FLAG = 'Y'
               SET CHK-FEE-WAIVED TO TRUE
           ELSE
               SET CHK-FEE-NOT-WAIVED TO TRUE
           END-IF
           GOBACK.
