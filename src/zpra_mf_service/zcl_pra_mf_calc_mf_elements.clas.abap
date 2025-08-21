CLASS zcl_pra_mf_calc_mf_elements DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS calculate_event_status_ind
      IMPORTING status                    TYPE zpra_mf_c_musicfestivaltp-status
      RETURNING VALUE(status_criticality) TYPE zpra_mf_c_musicfestivaltp-statuscriticality.
ENDCLASS.

CLASS zcl_pra_mf_calc_mf_elements IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA events TYPE STANDARD TABLE OF ZPRA_MF_C_MusicFestivalTP WITH DEFAULT KEY.
    events = CORRESPONDING #( it_original_data ).

    LOOP AT it_requested_calc_elements REFERENCE INTO DATA(req_calc_elements).

      CASE req_calc_elements->*.

        WHEN 'BOOKEDSEATS'.

          LOOP AT events REFERENCE INTO DATA(event).
            event->BookedSeats = event->MaxVisitorsNumber - event->FreeVisitorSeats.
          ENDLOOP.

        WHEN 'STATUSCRITICALITY'.

          LOOP AT events REFERENCE INTO event.
            event->StatusCriticality = zcl_pra_mf_calc_mf_elements=>calculate_event_status_ind( event->status ).
          ENDLOOP.

      ENDCASE.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( events ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    CLEAR: et_requested_orig_elements.

    IF iv_entity EQ `ZPRA_MF_C_MUSICFESTIVALTP`.
      IF line_exists( it_requested_calc_elements[ table_line = `BOOKEDSEATS` ] ).
        INSERT `MAXVISITORSNUMBER` INTO TABLE et_requested_orig_elements.
        INSERT `FREEVISITORSEATS` INTO TABLE et_requested_orig_elements.
      ENDIF.

      IF line_exists( it_requested_calc_elements[ table_line = `STATUSCRITICALITY` ] ).
        INSERT `STATUS` INTO TABLE et_requested_orig_elements.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD calculate_event_status_ind.

    CASE status.
      WHEN zcl_pra_mf_enum_mf_status=>cancelled.
        status_criticality = zcl_pra_mf_enum_criticality=>negative.
      WHEN zcl_pra_mf_enum_mf_status=>fully_booked.
        status_criticality = zcl_pra_mf_enum_criticality=>critical.
      WHEN zcl_pra_mf_enum_mf_status=>published.
        status_criticality = zcl_pra_mf_enum_criticality=>positive.
      WHEN OTHERS.
        status_criticality = zcl_pra_mf_enum_criticality=>neutral.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
