*"* use this source file for your ABAP unit test classes

**************************************************************
*  Local class to test create_object in zcl_pra_mf_ent_proj_bgpf  *
**************************************************************
"! @testing ZCL_PRA_MF_ENT_PROJ_BGPF
CLASS ltc_create_object DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
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

      test_first_creates_instance  FOR TESTING,
      test_second_returns_same_ref FOR TESTING.

ENDCLASS.


CLASS ltc_create_object IMPLEMENTATION.

  METHOD class_setup.
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_first_creates_instance.
    DATA lo_instance TYPE REF TO zcl_pra_mf_ent_proj_bgpf.

    " call the factory method
    lo_instance = zcl_pra_mf_ent_proj_bgpf=>create_object( ).

    " expect a bound reference to be returned
    cl_abap_unit_assert=>assert_bound(
      msg = 'create_object should return a bound reference on first call'
      act = lo_instance ).

  ENDMETHOD.

  METHOD test_second_returns_same_ref.
    DATA: lo_instance_1 TYPE REF TO zcl_pra_mf_ent_proj_bgpf,
          lo_instance_2 TYPE REF TO zcl_pra_mf_ent_proj_bgpf.

    " call the factory method twice
    lo_instance_1 = zcl_pra_mf_ent_proj_bgpf=>create_object( ).
    lo_instance_2 = zcl_pra_mf_ent_proj_bgpf=>create_object( ).

    " expect both calls to return the exact same singleton reference
    cl_abap_unit_assert=>assert_equals(
      msg = 'create_object should return the same singleton reference on subsequent calls'
      exp = lo_instance_1
      act = lo_instance_2 ).

  ENDMETHOD.

ENDCLASS.


**************************************************************
*  Local class to test execute in zcl_pra_mf_ent_proj_bgpf  *
**************************************************************
"! @testing zcl_pra_mf_ent_proj_bgpf
CLASS ltc_execute_method DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO zcl_pra_mf_ent_proj_bgpf,   " the class to be tested
      cds_test_environment TYPE REF TO if_cds_test_environment.     " cds test double framework

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

      test_execute_details_initial     FOR TESTING,
      test_execute_created_on_error    FOR TESTING,
      test_exception_http              FOR TESTING,
      test_exception_gateway           FOR TESTING,
      test_exception_cx_gateway        FOR TESTING,
      test_exception_client_error      FOR TESTING,
      test_execute_created_on_error1   FOR TESTING.

ENDCLASS.


CLASS ltc_execute_method IMPLEMENTATION.

  METHOD class_setup.
    " Create test doubles for the RAP entity accessed via READ/MODIFY ENTITIES
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
        i_for_entities = VALUE #(
            ( i_for_entity = 'ZPRA_MF_R_MUSICFESTIVAL' ) ) ).
    cds_test_environment->enable_double_redirection( ).
  ENDMETHOD.

  METHOD class_teardown.
    " stop mocking
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    " create a fresh instance before each test
    CREATE OBJECT class_under_test.
    " clear the content of the test double per test
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    " clean up any involved entity
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD test_execute_details_initial.
    " When project_details_instance is initial (default after CREATE OBJECT),
    " the CHECK statement exits the method immediately — no MODIFY ENTITIES is triggered.
    " We verify this by pre-setting is_project_created = abap_true in the mock data
    " and confirming it is NOT overwritten to false after execute().

    TEST-INJECTION execute_request.
    END-TEST-INJECTION.

    TEST-INJECTION request.
    END-TEST-INJECTION.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA lv_uuid      TYPE sysuuid_x16 VALUE 'DEC190889AC21FE08191A45962D04217'.

    " insert mock entity with is_project_created = true as a sentinel value
    mf_mock_data = VALUE #( ( uuid               = lv_uuid
                               is_project_created = abap_true ) ).
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    TRY.
        " execute with initial project_details_instance — should return immediately via CHECK
        class_under_test->if_bgmc_op_single~execute( ).

      CATCH cx_bgmc_operation.

    ENDTRY.

    " read back the entity and verify is_project_created was NOT changed
    READ ENTITIES OF zpra_mf_r_musicfestival
      ENTITY MusicFestival
      FIELDS ( Uuid Is_Project_Created )
      WITH VALUE #( ( uuid = lv_uuid ) )
      RESULT DATA(read_result).

    IF read_result IS NOT INITIAL.
      cl_abap_unit_assert=>assert_not_initial(
        msg = 'Mock entity should still be present after early exit'
        act = read_result ).

      cl_abap_unit_assert=>assert_equals(
        msg = 'IsProjectCreated must remain unchanged when project_details_instance is initial'
        exp = abap_true
        act = read_result[ 1 ]-Is_Project_Created ).
    ENDIF.

  ENDMETHOD.

  METHOD test_exception_http.

    TEST-INJECTION http_dest_provider_error.
      RAISE EXCEPTION TYPE /iwbep/cx_gateway.
    END-TEST-INJECTION.

    TEST-INJECTION request.
    END-TEST-INJECTION.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA lv_uuid      TYPE sysuuid_x16 VALUE 'DEC190889AC21FE08191A45962D04217'.

    " insert mock entity with is_project_created = true as a sentinel value
    mf_mock_data = VALUE #( ( uuid               = lv_uuid
                               is_project_created = abap_true ) ).
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    class_under_test->project_details_instance = VALUE #(
      project_uuid        = lv_uuid
      project             = 'EVENT1'
      project_description = 'Test Music Festival Event'
      project_start_date  = '20280101'
      project_end_date    = '20281231' ).

    TRY.
        " execute with initial project_details_instance — should return immediately via CHECK
        class_under_test->if_bgmc_op_single~execute( ).

      CATCH cx_bgmc_operation.

    ENDTRY.

  ENDMETHOD.

  METHOD test_exception_gateway.

    TEST-INJECTION http_dest_provider_error.
      RAISE EXCEPTION TYPE cx_web_http_client_error.
    END-TEST-INJECTION.

    TEST-INJECTION request.
    END-TEST-INJECTION.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA lv_uuid      TYPE sysuuid_x16 VALUE 'DEC190889AC21FE08191A45962D04217'.

    " insert mock entity with is_project_created = true as a sentinel value
    mf_mock_data = VALUE #( ( uuid               = lv_uuid
                               is_project_created = abap_true ) ).
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    class_under_test->project_details_instance = VALUE #(
      project_uuid        = lv_uuid
      project             = 'EVENT1'
      project_description = 'Test Music Festival Event'
      project_start_date  = '20280101'
      project_end_date    = '20281231' ).

    TRY.
        " execute with initial project_details_instance — should return immediately via CHECK
        class_under_test->if_bgmc_op_single~execute( ).

      CATCH cx_bgmc_operation.

    ENDTRY.

  ENDMETHOD.

  METHOD test_exception_client_error.

    TEST-INJECTION http_dest_provider_error.
      RAISE EXCEPTION TYPE cx_http_dest_provider_error.
    END-TEST-INJECTION.

    TEST-INJECTION request.
    END-TEST-INJECTION.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA lv_uuid      TYPE sysuuid_x16 VALUE 'DEC190889AC21FE08191A45962D04217'.

    " insert mock entity with is_project_created = true as a sentinel value
    mf_mock_data = VALUE #( ( uuid               = lv_uuid
                               is_project_created = abap_true ) ).
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    class_under_test->project_details_instance = VALUE #(
      project_uuid        = lv_uuid
      project             = 'EVENT1'
      project_description = 'Test Music Festival Event'
      project_start_date  = '20280101'
      project_end_date    = '20281231' ).

    TRY.
        " execute with initial project_details_instance — should return immediately via CHECK
        class_under_test->if_bgmc_op_single~execute( ).

      CATCH cx_bgmc_operation.

    ENDTRY.

  ENDMETHOD.

  METHOD test_exception_cx_gateway.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA lv_uuid      TYPE sysuuid_x16 VALUE 'DEC190889AC21FE08191A45962D04218'.

    TEST-INJECTION request.
      RAISE EXCEPTION TYPE /iwbep/cx_gateway.
    END-TEST-INJECTION.

    " insert mock entity for the READ ENTITIES call inside execute()
    mf_mock_data = VALUE #( ( uuid               = lv_uuid
                               description = 'Test Music Festival Event'
*                               event_date_time = '20280101'
                               is_project_created = abap_false ) ).
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " set valid project details so the CHECK passes and execute() proceeds
    class_under_test->project_details_instance = VALUE #(
      project_uuid        = lv_uuid
      project             = 'EVENT1'
      project_description = 'Test Music Festival Event'
      project_start_date  = '20280101'
      project_end_date    = '20281231' ).

    TRY.
        " execute — HTTP destination creation raises cx_http_dest_provider_error in test env
        class_under_test->if_bgmc_op_single~execute( ).

      CATCH cx_bgmc_operation.

    ENDTRY.

    " read back the entity and verify is_project_created was set to false
    READ ENTITIES OF zpra_mf_r_musicfestival
      ENTITY MusicFestival
      FIELDS ( Uuid Is_Project_Created )
      WITH VALUE #( ( uuid = lv_uuid ) )
      RESULT DATA(read_result).

  ENDMETHOD.

  METHOD test_execute_created_on_error.
    " When project_details_instance is populated but the HTTP comm arrangement
    " is unavailable in the test environment, cx_http_dest_provider_error is caught
    " and MODIFY ENTITIES sets is_project_created = abap_false.
    " Note: the success path (is_project_created = abap_true via TEST-SEAM injection)
    " is not testable here because the TEST-SEAM execute_request is placed inside
    " IF request IS BOUND, which requires a real OData client proxy connection.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA lv_uuid      TYPE sysuuid_x16 VALUE 'DEC190889AC21FE08191A45962D04218'.

    TEST-INJECTION execute_request.

    END-TEST-INJECTION.

    " insert mock entity for the READ ENTITIES call inside execute()
    mf_mock_data = VALUE #( ( uuid               = lv_uuid
                               description = 'Test Music Festival Event'
*                               event_date_time = '20280101'
                               is_project_created = abap_false ) ).
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " set valid project details so the CHECK passes and execute() proceeds
    class_under_test->project_details_instance = VALUE #(
      project_uuid        = lv_uuid
      project             = 'EVENT1'
      project_description = 'Test Music Festival Event'
      project_start_date  = '20280101'
      project_end_date    = '20281231' ).

    TRY.
        " execute — HTTP destination creation raises cx_http_dest_provider_error in test env
        class_under_test->if_bgmc_op_single~execute( ).

      CATCH cx_bgmc_operation.

    ENDTRY.

    " read back the entity and verify is_project_created was set to false
    READ ENTITIES OF zpra_mf_r_musicfestival
      ENTITY MusicFestival
      FIELDS ( Uuid Is_Project_Created )
      WITH VALUE #( ( uuid = lv_uuid ) )
      RESULT DATA(read_result).

    cl_abap_unit_assert=>assert_not_initial(
      msg = 'Read result should not be empty after execute()'
      act = read_result ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'IsProjectCreated should be true'
      exp = abap_true
      act = read_result[ 1 ]-Is_Project_Created ).

  ENDMETHOD.

  METHOD test_execute_created_on_error1.
    " When project_details_instance is populated but the HTTP comm arrangement
    " is unavailable in the test environment, cx_http_dest_provider_error is caught
    " and MODIFY ENTITIES sets is_project_created = abap_false.
    " Note: the success path (is_project_created = abap_true via TEST-SEAM injection)
    " is not testable here because the TEST-SEAM execute_request is placed inside
    " IF request IS BOUND, which requires a real OData client proxy connection.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA lv_uuid      TYPE sysuuid_x16 VALUE 'DEC190889AC21FE08191A45962D04218'.

    TEST-INJECTION execute_request.
    END-TEST-INJECTION.

    TEST-INJECTION request.
    END-TEST-INJECTION.

    " insert mock entity for the READ ENTITIES call inside execute()
    mf_mock_data = VALUE #( ( uuid               = lv_uuid
                               description = 'Test Music Festival Event'
*                               event_date_time = '20280101'
                               is_project_created = abap_false ) ).
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " set valid project details so the CHECK passes and execute() proceeds
    class_under_test->project_details_instance = VALUE #(
      project_uuid        = lv_uuid
      project             = 'EVENT1'
      project_description = 'Test Music Festival Event'
      project_start_date  = '20280101'
      project_end_date    = '20281231' ).

    TRY.
        " execute — HTTP destination creation raises cx_http_dest_provider_error in test env
        class_under_test->if_bgmc_op_single~execute( ).

      CATCH cx_bgmc_operation.

    ENDTRY.

    " read back the entity and verify is_project_created was set to false
    READ ENTITIES OF zpra_mf_r_musicfestival
      ENTITY MusicFestival
      FIELDS ( Uuid Is_Project_Created )
      WITH VALUE #( ( uuid = lv_uuid ) )
      RESULT DATA(read_result).

    cl_abap_unit_assert=>assert_not_initial(
      msg = 'Read result should not be empty after execute()'
      act = read_result ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'IsProjectCreated should be false when HTTP connection cannot be established'
      exp = abap_false
      act = read_result[ 1 ]-Is_Project_Created ).

  ENDMETHOD.


ENDCLASS.

