*"* use this source file for your ABAP unit test classes

CLASS ltc_filter DEFINITION FOR TESTING.

  PUBLIC SECTION.
    INTERFACES if_rap_query_filter.

ENDCLASS.


CLASS ltc_filter IMPLEMENTATION.
  METHOD if_rap_query_filter~get_as_tree.
  ENDMETHOD.

  METHOD if_rap_query_filter~get_as_sql_string.
  ENDMETHOD.

  METHOD if_rap_query_filter~get_as_ranges.
    rt_ranges = VALUE #( ( name = 'PROJECT' range = VALUE #( ( sign = 'I' option = 'CP' low = 'MF' ) ) ) ).
  ENDMETHOD.
ENDCLASS.


CLASS ltc_if_rap_query_request DEFINITION FOR TESTING.

  PUBLIC SECTION.
    INTERFACES if_rap_query_request.

ENDCLASS.


CLASS ltc_if_rap_query_request IMPLEMENTATION.
  METHOD if_rap_query_request~get_parameters.
  ENDMETHOD.

  METHOD if_rap_query_request~get_entity_id.
  ENDMETHOD.

  METHOD if_rap_query_request~get_aggregation.
  ENDMETHOD.

  METHOD if_rap_query_request~get_requested_elements.
  ENDMETHOD.

  METHOD if_rap_query_request~is_total_numb_of_rec_requested.
  ENDMETHOD.

  METHOD if_rap_query_request~get_filter.
    ro_filter = NEW ltc_filter( ).
  ENDMETHOD.

  METHOD if_rap_query_request~get_paging.
  ENDMETHOD.

  METHOD if_rap_query_request~get_sort_elements.
  ENDMETHOD.

  METHOD if_rap_query_request~get_search_expression.
  ENDMETHOD.

  METHOD if_rap_query_request~is_data_requested.
  ENDMETHOD.
ENDCLASS.


CLASS ltc_if_rap_query_response DEFINITION FOR TESTING.

  PUBLIC SECTION.
    INTERFACES if_rap_query_response.

ENDCLASS.


CLASS ltc_if_rap_query_response IMPLEMENTATION.
  METHOD if_rap_query_response~set_data.
  ENDMETHOD.

  METHOD if_rap_query_response~set_total_number_of_records.
  ENDMETHOD.
ENDCLASS.


CLASS ltc_pra_mf_fetch_proj DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO zcl_pra_mf_fetch_proj.
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.  " cds test double framework
    CLASS-DATA sql_test_environment TYPE REF TO if_osql_test_environment. " abap sql test double framework

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.
    METHODS select           FOR TESTING.
    METHODS select_scenario1 FOR TESTING.
    METHODS select_scenario2 FOR TESTING.
    METHODS select_scenario3 FOR TESTING.
    METHODS select_scenario4 FOR TESTING.

ENDCLASS.


CLASS ltc_pra_mf_fetch_proj IMPLEMENTATION.
  METHOD class_setup.
    class_under_test = NEW #( ).
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD select.
    TEST-INJECTION execute_request.

    END-TEST-INJECTION.

    DATA(query_request) = NEW ltc_if_rap_query_request( ).
    DATA(query_response) = NEW ltc_if_rap_query_response( ).
    DATA: prov_implementation TYPE REF TO cx_rap_query_prov_not_impl.
    DATA: provider TYPE REF TO cx_rap_query_provider.

    TRY.
        class_under_test->if_rap_query_provider~select( io_request  = query_request
                                                        io_response = query_response ).

      CATCH cx_rap_query_prov_not_impl INTO prov_implementation.
      CATCH cx_rap_query_provider INTO provider.

    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound( act = prov_implementation ).
    cl_abap_unit_assert=>assert_not_bound( act = provider ).
  ENDMETHOD.

  METHOD select_scenario1.
    TEST-INJECTION execute_request.

    END-TEST-INJECTION.

    TEST-INJECTION comm_arrang.
      CLEAR comm_arrang.
    END-TEST-INJECTION.

    TEST-INJECTION http_client.

    END-TEST-INJECTION.

    DATA(query_request) = NEW ltc_if_rap_query_request( ).
    DATA(query_response) = NEW ltc_if_rap_query_response( ).
    DATA: prov_implementation TYPE REF TO cx_rap_query_prov_not_impl.
    DATA: provider TYPE REF TO cx_rap_query_provider.

    TRY.
        class_under_test->if_rap_query_provider~select( io_request  = query_request
                                                        io_response = query_response ).

      CATCH cx_rap_query_prov_not_impl INTO prov_implementation.
      CATCH cx_rap_query_provider INTO provider.

    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound( act = prov_implementation ).
    cl_abap_unit_assert=>assert_not_bound( act = provider ).
  ENDMETHOD.

  METHOD select_scenario2.
    TEST-INJECTION execute_request.

    END-TEST-INJECTION.

    TEST-INJECTION http_client.
      RAISE EXCEPTION NEW cx_http_dest_provider_error( ).
    END-TEST-INJECTION.

    DATA(query_request) = NEW ltc_if_rap_query_request( ).
    DATA(query_response) = NEW ltc_if_rap_query_response( ).
    DATA: prov_implementation TYPE REF TO cx_rap_query_prov_not_impl.
    DATA: provider TYPE REF TO cx_rap_query_provider.

    TRY.
        class_under_test->if_rap_query_provider~select( io_request  = query_request
                                                        io_response = query_response ).

      CATCH cx_rap_query_prov_not_impl INTO prov_implementation.
      CATCH cx_rap_query_provider INTO provider.

    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound( act = prov_implementation ).
    cl_abap_unit_assert=>assert_not_bound( act = provider ).
  ENDMETHOD.

  METHOD select_scenario3.
    TEST-INJECTION execute_request.

    END-TEST-INJECTION.

    TEST-INJECTION http_client.
      RAISE EXCEPTION NEW /iwbep/cx_gateway( ).
    END-TEST-INJECTION.

    DATA(query_request) = NEW ltc_if_rap_query_request( ).
    DATA(query_response) = NEW ltc_if_rap_query_response( ).
    DATA: prov_implementation TYPE REF TO cx_rap_query_prov_not_impl.
    DATA: provider TYPE REF TO cx_rap_query_provider.

    TRY.
        class_under_test->if_rap_query_provider~select( io_request  = query_request
                                                        io_response = query_response ).

      CATCH cx_rap_query_prov_not_impl INTO prov_implementation.
      CATCH cx_rap_query_provider INTO provider.

    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound( act = prov_implementation ).
    cl_abap_unit_assert=>assert_not_bound( act = provider ).
  ENDMETHOD.

  METHOD select_scenario4.
    TEST-INJECTION execute_request.

    END-TEST-INJECTION.

    TEST-INJECTION http_client.
      RAISE EXCEPTION NEW cx_web_http_client_error( ).
    END-TEST-INJECTION.

    DATA(query_request) = NEW ltc_if_rap_query_request( ).
    DATA(query_response) = NEW ltc_if_rap_query_response( ).
    DATA: prov_implementation TYPE REF TO cx_rap_query_prov_not_impl.
    DATA: provider TYPE REF TO cx_rap_query_provider.

    TRY.
        class_under_test->if_rap_query_provider~select( io_request  = query_request
                                                        io_response = query_response ).

      CATCH cx_rap_query_prov_not_impl INTO prov_implementation.
      CATCH cx_rap_query_provider INTO provider.

    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound( act = prov_implementation ).
    cl_abap_unit_assert=>assert_not_bound( act = provider ).
  ENDMETHOD.
ENDCLASS.
