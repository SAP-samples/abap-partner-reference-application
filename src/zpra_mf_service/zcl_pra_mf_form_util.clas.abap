CLASS zcl_pra_mf_form_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: trace_level_detailed TYPE int4 VALUE 4,
               locale_en            TYPE string VALUE 'en_US'.
    METHODS get_fp_fdp_service
      IMPORTING application_service_def TYPE if_fp_fdp_api=>ty_service_definition
      RETURNING VALUE(fp_fdp_service)   TYPE REF TO if_fp_fdp_api
      RAISING   cx_fp_fdp_error .
    METHODS render_form_for_preview
      IMPORTING id               TYPE sysuuid_x16
                form_template    TYPE fpname
                fp_fdp_service   TYPE REF TO if_fp_fdp_api
      RETURNING VALUE(outputPdf) TYPE zpra_mf_c_musicfestivaltp-OutputPdfData
      RAISING   cx_fp_fdp_error cx_fp_form_reader cx_fp_ads_util .

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA application_service_def TYPE if_fp_fdp_api=>ty_service_definition.
    DATA form_template TYPE fpname.

    METHODS get_application_metadata
      IMPORTING id              TYPE sysuuid_x16
                fp_fdp_service  TYPE REF TO if_fp_fdp_api
      RETURNING VALUE(xml_data) TYPE xstring
      RAISING   cx_fp_fdp_error .

    CLASS-DATA: skip           TYPE abap_bool VALUE  abap_false.

ENDCLASS.

CLASS zcl_pra_mf_form_util IMPLEMENTATION.

  METHOD get_fp_fdp_service.

    fp_fdp_service = cl_fp_fdp_services=>get_instance( application_service_def ).

  ENDMETHOD.

  METHOD get_application_metadata.

    " Extract the keys for the music event
    DATA(event_keys) = fp_fdp_service->get_keys(  ).
    event_keys[ name = 'UUID' ]-value = id."uuid for the list id.

    " retrieves the data structure of the music festival application service definition for a specific UUID.
    DATA(event_details_xml_format) = fp_fdp_service->read_to_xml_v2(
                                                                    it_select     = event_keys
                                                                    it_select_add = VALUE if_fp_fdp_api=>tt_select_keys(
                                                                                              ( name      = 'IsActiveEntity'
                                                                                                value     = abap_true
                                                                                                data_type = 'ABAP_BOOL' ) ) ).

    xml_data = event_details_xml_format.

  ENDMETHOD.


  METHOD render_form_for_preview.

    "Avoid infinite loop within the form service
    IF skip = abap_true.
      RETURN.
    ELSE.
      skip = abap_true.
    ENDIF.

    DATA(event_detail_xml) = get_application_metadata(  id              = id
                                                        fp_fdp_service  = fp_fdp_service ).
    DATA(form_ref) = cl_fp_form_reader=>create_form_reader( form_template ).

    " Converting XML to pdf
    cl_fp_ads_util=>render_pdf(
                              EXPORTING
                                iv_xml_data   = event_detail_xml
                                iv_xdp_layout = form_ref->get_layout( )
                                iv_locale     = locale_en
                                is_options    = VALUE #( trace_level = trace_level_detailed )
                              IMPORTING
                                ev_pdf        = DATA(gen_event_pdf) ).

    outputPdf = gen_event_pdf.
  ENDMETHOD.

ENDCLASS.
