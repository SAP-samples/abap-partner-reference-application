CLASS zcl_pra_mf_enum_visit_status DEFINITION PUBLIC ABSTRACT FINAL.

  PUBLIC SECTION.
    CONSTANTS:
      pending   TYPE ZPRA_MF_C_VisitTP-Status VALUE 'P',
      cancelled TYPE ZPRA_MF_C_VisitTP-Status VALUE 'C',
      booked    TYPE ZPRA_MF_C_VisitTP-Status VALUE 'B'.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_pra_mf_enum_visit_status IMPLEMENTATION.
ENDCLASS.
