*"* use this source file for your ABAP unit test classes

CLASS ltc_if_rap_query_request DEFINITION.

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


CLASS ltc_if_rap_query_response DEFINITION.

  PUBLIC SECTION.
    INTERFACES if_rap_query_response.

ENDCLASS.

CLASS ltc_if_rap_query_response IMPLEMENTATION.

  METHOD if_rap_query_response~set_data.

  ENDMETHOD.

  METHOD if_rap_query_response~set_total_number_of_records.

  ENDMETHOD.

ENDCLASS.

CLASS ltc_pra_mf_fetch_proj DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO  zcl_pra_mf_fetch_proj,
      cds_test_environment TYPE REF TO if_cds_test_environment,  " cds test double framework
      sql_test_environment TYPE REF TO if_osql_test_environment. " abap sql test double framework

    CLASS-METHODS:
      " setup test double framework
      class_setup,
      " stop test doubles
      class_teardown.

    METHODS:
      " reset test doubles
      setup,
      " rollback any changes
      teardown,
      select FOR TESTING.

ENDCLASS.

CLASS ltc_pra_mf_fetch_proj IMPLEMENTATION.

  METHOD class_setup.

    CREATE OBJECT class_under_test.

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

    TRY.
        class_under_test->if_rap_query_provider~select( io_request = query_request
                                                        io_response = query_response ).

      CATCH cx_rap_query_prov_not_impl INTO DATA(prov_implementation).
      CATCH cx_rap_query_provider INTO DATA(provider).

    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound( act = prov_implementation ).
    cl_abap_unit_assert=>assert_not_bound( act = provider ).

  ENDMETHOD.

ENDCLASS.
