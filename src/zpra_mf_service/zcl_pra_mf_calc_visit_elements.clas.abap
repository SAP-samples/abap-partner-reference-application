CLASS zcl_pra_mf_calc_visit_elements DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS calculate_status_criticality
      IMPORTING status                    TYPE zpra_mf_c_visittp-status
      RETURNING VALUE(status_criticality) TYPE zpra_mf_c_visittp-statuscriticality.
ENDCLASS.



CLASS zcl_pra_mf_calc_visit_elements IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA visits TYPE STANDARD TABLE OF zpra_mf_c_visittp WITH DEFAULT KEY.
    visits = CORRESPONDING #( it_original_data ).

    LOOP AT it_requested_calc_elements REFERENCE INTO DATA(req_calc_elements).

      CASE req_calc_elements->*.

        WHEN 'STATUSCRITICALITY'.

          LOOP AT visits REFERENCE INTO DATA(visit).
            visit->StatusCriticality = zcl_pra_mf_calc_visit_elements=>calculate_status_criticality( visit->status ).
          ENDLOOP.

      ENDCASE.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( visits ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    IF iv_entity EQ 'ZPRA_MF_C_VISITTP'.
      LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<requested_calc_elements>).
        CASE <requested_calc_elements>.
          WHEN 'STATUSCRITICALITY'.
            APPEND 'STATUS' TO et_requested_orig_elements.
        ENDCASE.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD calculate_status_criticality.

    CASE status.
      WHEN zcl_pra_mf_enum_visit_status=>cancelled.
        status_criticality = zcl_pra_mf_enum_criticality=>negative.
      WHEN zcl_pra_mf_enum_visit_status=>pending.
        status_criticality = zcl_pra_mf_enum_criticality=>critical.
      WHEN zcl_pra_mf_enum_visit_status=>booked.
        status_criticality = zcl_pra_mf_enum_criticality=>positive.
      WHEN OTHERS.
        status_criticality = zcl_pra_mf_enum_criticality=>neutral.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
