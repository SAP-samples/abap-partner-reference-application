CLASS zcl_pra_mf_calc_mf_elements DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.

    CLASS-DATA skip TYPE abap_bool VALUE abap_false.

    DATA sales_order_url_base TYPE string.


  PRIVATE SECTION.
    CONSTANTS mc_mime_type TYPE string VALUE 'application/pdf'.

    DATA form_util TYPE REF TO zif_pra_mf_form_util.

    METHODS calculate_event_status_ind
      IMPORTING !status       TYPE zpra_mf_c_musicfestivaltp-Status
      RETURNING VALUE(result) TYPE zpra_mf_c_musicfestivaltp-StatusCriticality.

ENDCLASS.



CLASS ZCL_PRA_MF_CALC_MF_ELEMENTS IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA events TYPE STANDARD TABLE OF ZPRA_MF_C_MusicFestivalTP WITH EMPTY KEY.
    DATA url TYPE string.
    DATA ca_range TYPE if_com_scenario_factory=>ty_query-cscn_id_range.
    DATA comm_arrang TYPE STANDARD TABLE OF REF TO if_com_arrangement.

    CONSTANTS sales_order_constant TYPE string VALUE 'ui#SalesOrder-manageV2&/SalesOrderManage' ##NO_TEXT.


    CONSTANTS lc_comm_sys_id   TYPE if_com_system=>ty_cs-id VALUE 'ZPRA_MF_S4HC'.
    CONSTANTS lc_proj_scenario TYPE if_com_arrangement_v2=>ty_ca-cscn_id VALUE 'ZPRA_MF_CS_ENT_PROJ'.

    IF sales_order_url_base IS INITIAL
       AND line_exists( it_requested_calc_elements[ table_line = 'SALESORDERURL' ] ).

      DATA(lo_com_util) = NEW zcl_pra_mf_com_util( ).
      DATA base_url TYPE string.

      TRY.
          base_url = lo_com_util->zif_pra_mf_com_util~get_host_from_comm_system( iv_system_id = lc_comm_sys_id ).

          IF base_url IS INITIAL.
            base_url = lo_com_util->zif_pra_mf_com_util~get_host_from_comm_arrangement( iv_scenario = lc_proj_scenario ).
          ENDIF.

        CATCH cx_static_check cx_dynamic_check ##NO_HANDLER.
      ENDTRY.

      IF base_url IS NOT INITIAL.
        " Ensures there is a trailing slash between the host domain and the Fiori intent hash
        IF substring( val = base_url off = strlen( base_url ) - 1 len = 1 ) <> '/'.
          base_url = |{ base_url }/|.
        ENDIF.

        sales_order_url_base = |{ base_url }{ sales_order_constant }|.
      ENDIF.
    ENDIF.

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

          WHEN 'SALESORDERURL'.
            " 3. Finish building the dynamic link string for the row
            IF sales_order_url_base IS NOT INITIAL AND event->SalesOrderId IS NOT INITIAL.
              ASSIGN COMPONENT 'SALESORDERURL' OF STRUCTURE event->* TO FIELD-SYMBOL(<fs_url>).
              IF <fs_url> IS ASSIGNED.
                <fs_url> = |{ sales_order_url_base }('{ event->SalesOrderId }')|.
              ENDIF.
            ENDIF.

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

          WHEN 'HIDESPONSORINGDATA'.
            event->HideSponsoringData = xsdbool( event->SalesOrderId IS INITIAL ).

        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( events ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    CLEAR et_requested_orig_elements.

    IF iv_entity <> `ZPRA_MF_C_MUSICFESTIVALTP` AND iv_entity <> `ZPRA_MF_C_MUSICFESTIVAL_API`.
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

    IF line_exists( it_requested_calc_elements[ table_line = `SALESORDERURL` ] ).
      INSERT `SALESORDERID` INTO TABLE et_requested_orig_elements.
    ENDIF.

    IF line_exists( it_requested_calc_elements[ table_line = `HIDESPONSORINGDATA` ] ).
      INSERT `SALESORDERID` INTO TABLE et_requested_orig_elements.
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
