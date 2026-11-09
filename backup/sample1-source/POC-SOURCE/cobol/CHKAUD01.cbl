       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHKAUD01.
      *================================================================*
      * PROGRAM  : CHKAUD01  - AUDIT TRAIL (CALLED DYNAMICALLY)        *
      *================================================================*
       DATA DIVISION.
       LINKAGE SECTION.
       01  LS-LOG-AREA.
           05  LS-CHECK-NO             PIC X(10).
           05  LS-FEE                  PIC S9(07)V99 COMP-3.
       PROCEDURE DIVISION USING LS-LOG-AREA.
       0000-MAIN.
           DISPLAY 'CHKAUD01 CHECK=' LS-CHECK-NO
           GOBACK.
