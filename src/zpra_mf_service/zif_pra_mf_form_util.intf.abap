INTERFACE zif_pra_mf_form_util
  PUBLIC.

  CONSTANTS trace_level_detailed TYPE int4   VALUE 4.
  CONSTANTS locale_en            TYPE string VALUE 'en_US'.

  METHODS get_fp_fdp_service
    IMPORTING application_service_def TYPE if_fp_fdp_api=>ty_service_definition
    RETURNING VALUE(result)   TYPE REF TO if_fp_fdp_api
    RAISING   cx_fp_fdp_error.

  METHODS render_form_for_preview
    IMPORTING !id              TYPE sysuuid_x16
              form_template    TYPE fpname
              fp_fdp_service   TYPE REF TO if_fp_fdp_api
    RETURNING VALUE(result) TYPE zpra_mf_c_musicfestivaltp-OutputPdfData
    RAISING   cx_fp_fdp_error cx_fp_form_reader cx_fp_ads_util.

  METHODS render_form_for_print_queue
    IMPORTING !id              TYPE sysuuid_x16
              pq_name          TYPE cl_fp_ads_util=>ty_pq_name
              form_template    TYPE fpname
              fp_fdp_service   TYPE REF TO if_fp_fdp_api
    RETURNING VALUE(result) TYPE xstring
    RAISING   cx_fp_fdp_error cx_fp_form_reader cx_fp_ads_util.

ENDINTERFACE.
