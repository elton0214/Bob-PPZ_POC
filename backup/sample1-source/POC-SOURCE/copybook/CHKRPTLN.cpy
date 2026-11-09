      *================================================================*
      * COPYBOOK : CHKRPTLN                                            *
      * PURPOSE  : RETURNED CHECK FEE REPORT LINE LAYOUTS (LRECL=80)   *
      *================================================================*
       01  RPT-HEADER-1.
           05  FILLER                  PIC X(30)
                                       VALUE 'RETURNED CHECK FEE REPORT'.
           05  FILLER                  PIC X(50) VALUE SPACES.
       01  RPT-FEE-NOTE.
           05  FILLER                  PIC X(20)
                                       VALUE 'STANDARD FEE (TWD): '.
           05  RPT-STD-FEE             PIC ZZZ,ZZ9.99.
           05  FILLER                  PIC X(50) VALUE SPACES.
       01  RPT-DETAIL.
           05  RPT-CHECK-NO            PIC X(10).
           05  FILLER                  PIC X(02) VALUE SPACES.
           05  RPT-ACCT-NO             PIC X(12).
           05  FILLER                  PIC X(02) VALUE SPACES.
           05  RPT-CHECK-AMT           PIC Z,ZZZ,ZZZ,ZZ9.99.
           05  FILLER                  PIC X(02) VALUE SPACES.
           05  RPT-FEE-AMT             PIC ZZZ,ZZ9.99.
           05  FILLER                  PIC X(26) VALUE SPACES.
       01  RPT-TOTAL-LINE.
           05  FILLER                  PIC X(20)
                                       VALUE 'TOTAL FEE (TWD):    '.
           05  RPT-TOTAL-FEE           PIC ZZZ,ZZZ,ZZ9.99.
           05  FILLER                  PIC X(46) VALUE SPACES.
