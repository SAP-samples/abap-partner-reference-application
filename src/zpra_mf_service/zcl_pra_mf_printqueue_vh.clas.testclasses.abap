*"* use this source file for your ABAP unit test classes
" Local test helper class for query response
CLASS ltcl_query_response_helper DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_rap_query_response.

    DATA mt_data          TYPE STANDARD TABLE OF zpra_mf_ce_printqueue_vh WITH EMPTY KEY.
    DATA mv_total_records TYPE i.

ENDCLASS.


CLASS ltcl_query_response_helper IMPLEMENTATION.
  METHOD if_rap_query_response~set_data.
    mt_data = it_data.
  ENDMETHOD.

  METHOD if_rap_query_response~set_total_number_of_records.
    mv_total_records = iv_total_number_of_records.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_zcl_pra_mf_printqueue_vh DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut                    TYPE REF TO zcl_pra_mf_printqueue_vh.
    DATA rap_query_request_mock TYPE REF TO if_rap_query_request.
    DATA printqueue_vh_response TYPE REF TO ltcl_query_response_helper.

    METHODS setup.
    METHODS teardown.
    METHODS default_printqueue_exist FOR TESTING.

ENDCLASS.


CLASS ltcl_zcl_pra_mf_printqueue_vh IMPLEMENTATION.
  METHOD setup.
    cut = NEW #( ).
    printqueue_vh_response = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR cut.
  ENDMETHOD.

  METHOD default_printqueue_exist.
    " Create test doubles for request
    rap_query_request_mock = CAST #( cl_abap_testdouble=>create( 'IF_RAP_QUERY_REQUEST' ) ).

    DATA is_data_requested TYPE abap_bool VALUE abap_true.
    cl_abap_testdouble=>configure_call( rap_query_request_mock )->returning( is_data_requested ).
    rap_query_request_mock->is_data_requested( ).

    TRY.
        cut->if_rap_query_provider~select( io_request  = rap_query_request_mock
                                           io_response = printqueue_vh_response ).

      CATCH cx_rap_query_prov_not_impl
            cx_rap_query_provider INTO DATA(error). " TODO: variable is assigned but never used (ABAP cleaner)
        " Fail the test if exception occurs
        cl_abap_unit_assert=>fail( ).
    ENDTRY.

    " Then: Assert DEFAULT print queue exists
    cl_abap_unit_assert=>assert_table_contains( line  = VALUE zpra_mf_ce_printqueue_vh( print_queue = 'DEFAULT' )
                                                table = printqueue_vh_response->mt_data ).
  ENDMETHOD.
ENDCLASS.
