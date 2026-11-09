      *================================================================*
      * COPYBOOK : CHKERRCD                                            *
      * PURPOSE  : CHECK SYSTEM ERROR CODES                            *
      *================================================================*
       01  CHK-ERROR-CODES.
           05  ERR-BAD-REASON          PIC X(04) VALUE 'E001'.
           05  ERR-NO-ACCT             PIC X(04) VALUE 'E002'.
           05  ERR-DB2-FAIL            PIC X(04) VALUE 'E003'.
