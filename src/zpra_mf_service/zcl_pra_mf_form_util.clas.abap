CLASS zcl_pra_mf_form_util DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_pra_mf_form_util.

    ALIASES trace_level_detailed        FOR zif_pra_mf_form_util~trace_level_detailed.
    ALIASES locale_en                   FOR zif_pra_mf_form_util~locale_en.
    ALIASES get_fp_fdp_service          FOR zif_pra_mf_form_util~get_fp_fdp_service.
    ALIASES render_form_for_preview     FOR zif_pra_mf_form_util~render_form_for_preview.
    ALIASES render_form_for_print_queue FOR zif_pra_mf_form_util~render_form_for_print_queue.

  PRIVATE SECTION.
    DATA application_service_def TYPE if_fp_fdp_api=>ty_service_definition.
    DATA form_template           TYPE fpname.

    METHODS get_application_metadata
      IMPORTING !id             TYPE sysuuid_x16
                fp_fdp_service  TYPE REF TO if_fp_fdp_api
      RETURNING VALUE(result) TYPE xstring
      RAISING   cx_fp_fdp_error.

    CLASS-DATA skip TYPE abap_bool VALUE abap_false.

ENDCLASS.



CLASS ZCL_PRA_MF_FORM_UTIL IMPLEMENTATION.


  METHOD get_fp_fdp_service.
    result = cl_fp_fdp_services=>get_instance( application_service_def ).
  ENDMETHOD.


  METHOD get_application_metadata.
    " Extract the keys for the music event
    DATA(event_keys) = fp_fdp_service->get_keys( ).
    event_keys[ name = 'UUID' ]-value = id. " uuid for the list id.

    " retrieves the data structure of the music festival application service definition for a specific UUID.
    DATA(event_details_xml_format) = fp_fdp_service->read_to_xml_v2(
                                         it_select     = event_keys
                                         it_select_add = VALUE if_fp_fdp_api=>tt_select_keys(
                                                                   ( name      = 'IsActiveEntity'
                                                                     value     = abap_true
                                                                     data_type = 'ABAP_BOOL' ) ) ).

    result = event_details_xml_format.
  ENDMETHOD.


  METHOD render_form_for_preview.
    " Avoid infinite loop within the form service
    IF skip = abap_true.
      RETURN.
    ELSE.
      skip = abap_true.
    ENDIF.

    DATA(event_detail_xml) = get_application_metadata( id             = id
                                                       fp_fdp_service = fp_fdp_service ).
    DATA(form_ref) = cl_fp_form_reader=>create_form_reader( form_template ).

    " Converting XML to pdf
    cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data   = event_detail_xml
                                          iv_xdp_layout = form_ref->get_layout( )
                                          iv_locale     = locale_en
                                          is_options    = VALUE #( trace_level = trace_level_detailed )
                                IMPORTING ev_pdf        = DATA(gen_event_pdf) ).

    result = gen_event_pdf.
  ENDMETHOD.


  METHOD render_form_for_print_queue.
    " Avoid infinite loop within the form service
    IF skip = abap_true.
      RETURN.
    ELSE.
      skip = abap_true.
    ENDIF.

    DATA(event_detail_xml) = get_application_metadata( id             = id
                                                       fp_fdp_service = fp_fdp_service ).
    DATA(form_ref) = cl_fp_form_reader=>create_form_reader( form_template ).

    " Converting XML to pdf
    cl_fp_ads_util=>render_4_pq( EXPORTING iv_xml_data   = event_detail_xml
                                           iv_pq_name    = pq_name
                                           iv_xdp_layout = form_ref->get_layout( )
                                           iv_locale     = locale_en
                                           is_options    = VALUE #( trace_level = trace_level_detailed )
                                 IMPORTING ev_pdl        = DATA(gen_event_pdl) ).

    result = gen_event_pdl.
  ENDMETHOD.
ENDCLASS.
