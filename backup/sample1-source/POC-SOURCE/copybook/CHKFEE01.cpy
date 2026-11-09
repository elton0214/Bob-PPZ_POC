      *================================================================*
      * COPYBOOK : CHKFEE01                                            *
      * PURPOSE  : RETURNED CHECK FEE PARAMETERS                       *
      * SYSTEM   : CHECK DEPOSIT (CHK)                                 *
      *================================================================*
       01  CHK-FEE-PARMS.
           05  CHK-FEE-STD-AMT         PIC S9(07)V99 COMP-3
                                       VALUE +150.00.
           05  CHK-FEE-CURRENCY        PIC X(03) VALUE 'TWD'.
           05  CHK-FEE-WAIVE-FLAG      PIC X(01) VALUE 'N'.
               88  CHK-FEE-WAIVED      VALUE 'Y'.
               88  CHK-FEE-NOT-WAIVED  VALUE 'N'.
           05  CHK-FEE-DESC            PIC X(20)
                                       VALUE 'RETURNED CHECK FEE'.
