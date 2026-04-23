CLASS zcl_pra_mf_calc_mf_elements DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.

    CLASS-DATA skip TYPE abap_bool VALUE abap_false.

  PRIVATE SECTION.
    CONSTANTS mc_mime_type TYPE string VALUE 'application/pdf'.

    DATA form_util TYPE REF TO zif_pra_mf_form_util.

    METHODS calculate_event_status_ind
      IMPORTING !status                   TYPE zpra_mf_c_musicfestivaltp-Status
      RETURNING VALUE(result) TYPE zpra_mf_c_musicfestivaltp-StatusCriticality.

ENDCLASS.



CLASS ZCL_PRA_MF_CALC_MF_ELEMENTS IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA events TYPE STANDARD TABLE OF ZPRA_MF_C_MusicFestivalTP WITH EMPTY KEY.

    events = CORRESPONDING #( it_original_data ).
    LOOP AT events REFERENCE INTO DATA(event).
      LOOP AT it_requested_calc_elements REFERENCE INTO DATA(req_calc_elements).

        CASE req_calc_elements->*.

          WHEN 'BOOKEDSEATS'.
            event->BookedSeats = event->MaxVisitorsNumber - event->FreeVisitorSeats.

          WHEN 'STATUSCRITICALITY'.
            event->StatusCriticality = calculate_event_status_ind( event->status ).

          WHEN 'MIMETYPE'.
            event->MimeType = mc_mime_type.

          WHEN 'HYPERLINKTEXT'.
            event->HyperLinkText = event->Title.

          WHEN 'OUTPUTPDFDATA'.

            IF NEW zcl_pra_mf_com_util( )->zif_pra_mf_com_util~is_scenario_configured( 'SAP_COM_0503' ) = abap_true.
              TRY.
                  IF form_util IS NOT BOUND.
                    form_util = NEW zcl_pra_mf_form_util( ).
                  ENDIF.
                  DATA(fp_fdp_service) = form_util->get_fp_fdp_service( 'ZPRA_MF_MUSICFESTIVAL' ).
                  event->OutputPdfData = form_util->render_form_for_preview( id             = event->Uuid
                                                                             form_template  = 'ZPRA_MF_PDF_FORM_MF'
                                                                             fp_fdp_service = fp_fdp_service ).

                CATCH cx_fp_fdp_error
                      cx_fp_form_reader
                      cx_fp_ads_util INTO DATA(exception).

                  RAISE EXCEPTION NEW zcx_pra_mf_calc_exit( previous = exception
                                                            textid   = zcx_pra_mf_calc_exit=>exception_forms ).

              ENDTRY.
            ENDIF.

        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( events ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    CLEAR et_requested_orig_elements.

    IF iv_entity <> `ZPRA_MF_C_MUSICFESTIVALTP`.
      RETURN.
    ENDIF.

    IF line_exists( it_requested_calc_elements[ table_line = `BOOKEDSEATS` ] ).
      INSERT `MAXVISITORSNUMBER` INTO TABLE et_requested_orig_elements.
      INSERT `FREEVISITORSEATS` INTO TABLE et_requested_orig_elements.
    ENDIF.

    IF line_exists( it_requested_calc_elements[ table_line = `STATUSCRITICALITY` ] ).
      INSERT `STATUS` INTO TABLE et_requested_orig_elements.
    ENDIF.

    IF line_exists( it_requested_calc_elements[ table_line = `OUTPUTPDFDATA` ] ).
      INSERT `UUID` INTO TABLE et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.


  METHOD calculate_event_status_ind.
    CASE status.
      WHEN zcl_pra_mf_enum_mf_status=>cancelled.
        result = zcl_pra_mf_enum_criticality=>negative.
      WHEN zcl_pra_mf_enum_mf_status=>fully_booked.
        result = zcl_pra_mf_enum_criticality=>critical.
      WHEN zcl_pra_mf_enum_mf_status=>published.
        result = zcl_pra_mf_enum_criticality=>positive.
      WHEN OTHERS.
        result = zcl_pra_mf_enum_criticality=>neutral.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
