CLASS zcl_pra_mf_bgmc_op_print_util DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF print_request_structure,
             form_name   TYPE fpname,
             print_queue TYPE c LENGTH 32,
             fdp_srvd    TYPE c LENGTH 40,
             uuid        TYPE sysuuid_x16,
           END OF print_request_structure.

    INTERFACES if_bgmc_op_single_tx_uncontr.

    ALIASES execute FOR if_bgmc_op_single_tx_uncontr~execute.

    METHODS constructor
      IMPORTING print_input_data TYPE print_request_structure.

  PRIVATE SECTION.
    DATA print_request  TYPE print_request_structure.
    DATA fp_fdp_service TYPE REF TO if_fp_fdp_api.
ENDCLASS.



CLASS ZCL_PRA_MF_BGMC_OP_PRINT_UTIL IMPLEMENTATION.


  METHOD constructor.
    print_request = print_input_data.
  ENDMETHOD.


  METHOD execute.
    TRY.

        DATA(form_util) = NEW zcl_pra_mf_form_util( ).

        IF fp_fdp_service IS INITIAL.
          fp_fdp_service = form_util->get_fp_fdp_service( print_request-fdp_srvd ).
        ENDIF.

        DATA(event_pdl) = form_util->render_form_for_print_queue( id             = print_request-uuid
                                                                  pq_name        = print_request-print_queue
                                                                  form_template  = print_request-form_name
                                                                  fp_fdp_service = fp_fdp_service ).

        TEST-SEAM create_pq. "#EC TEST_SEAM_USAGE
          cl_print_queue_utils=>create_queue_item_by_data( iv_qname            = print_request-print_queue
                                                           iv_print_data       = event_pdl
                                                           iv_name_of_main_doc = |MFM-{ print_request-uuid }| ).
        END-TEST-SEAM.

      CATCH cx_fp_fdp_error
            cx_fp_form_reader
            cx_fp_ads_util INTO DATA(exception).
        RAISE EXCEPTION NEW cx_bgmc_operation( previous       = exception
                                               textid         = cx_bgmc_operation=>t100_operation_failed
                                               retry_settings = VALUE #( delay_time = 2
                                                                         do_retry   = abap_true ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
