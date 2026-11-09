      *================================================================*
      * COPYBOOK : CHKMSTRC                                            *
      * PURPOSE  : CHECK ACCOUNT MASTER RECORD (VSAM KSDS)             *
      *            DATASET: CHK.MASTER.KSDS                            *
      *================================================================*
       01  CHK-MASTER-REC.
           05  MST-ACCT-NO             PIC X(12).
           05  MST-ACCT-NAME           PIC X(20).
           05  MST-ACCT-STATUS         PIC X(01).
               88  MST-ACTIVE          VALUE 'A'.
               88  MST-CLOSED          VALUE 'C'.
           05  MST-BALANCE             PIC S9(11)V99 COMP-3.
           05  FILLER                  PIC X(20).
