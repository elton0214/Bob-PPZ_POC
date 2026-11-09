      *================================================================*
      * COPYBOOK : CHKRTNRC                                            *
      * PURPOSE  : RETURNED CHECK INPUT RECORD (LRECL=80, FB)          *
      *================================================================*
       01  CHK-RETURN-REC.
           05  RTN-CHECK-NO            PIC X(10).
           05  RTN-ACCT-NO             PIC X(12).
           05  RTN-CHECK-AMT           PIC 9(11)V99.
           05  RTN-RETURN-DATE         PIC 9(08).
           05  RTN-REASON-CODE         PIC X(02).
               88  RTN-NSF             VALUE '01'.
               88  RTN-SIGN-MISMATCH   VALUE '02'.
               88  RTN-ACCT-CLOSED     VALUE '03'.
           05  FILLER                  PIC X(35).
