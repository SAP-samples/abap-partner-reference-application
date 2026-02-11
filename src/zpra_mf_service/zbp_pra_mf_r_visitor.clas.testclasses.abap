*"* use this source file for your ABAP unit test classes
**************************************************************
*  Local class to test validations in behavior implementations         *
**************************************************************
"! @testing BDEF:ZPRA_MF_R_VISITOR
CLASS ltc_authorization_methods DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_zpra_mf_r_visitor,    " the class to be tested
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
      " roll back any changes
      teardown,
      get_global_authorizations FOR TESTING,
      get_instance_authorizations FOR TESTING.

    TYPES reported_early TYPE RESPONSE FOR REPORTED EARLY ZPRA_MF_R_Visitor.
    TYPES failed_early TYPE RESPONSE FOR FAILED EARLY ZPRA_MF_R_Visitor.

    DATA : ms_reported_early TYPE reported_early.
    DATA : ms_failed_early   TYPE failed_early.
ENDCLASS.


CLASS ltc_authorization_methods IMPLEMENTATION.


  METHOD class_setup.
    " Create the class under Test
    " The class is abstract but can be constructed with the FOR TESTING
    CREATE OBJECT class_under_test FOR TESTING.
    " Create test doubles for database dependencies
    " The EML READ operation will then also access the test doubles
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds( i_for_entities = VALUE #(
        ( i_for_entity = 'ZPRA_MF_R_VISITOR '
        i_select_base_dependencies = abap_true
        i_dependency_list = VALUE #( ( 'ZPRA_MF_A_VSTR' ) ) ) ) ).

  ENDMETHOD.

  METHOD class_teardown.
    " stop mocking
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
  DATA test_keys TYPE TABLE FOR AUTHORIZATION KEY ZPRA_MF_R_Visitor\\Visitor.
    " clear the content of the test double per test
    cds_test_environment->clear_doubles( ).

  ENDMETHOD.

  METHOD teardown.
    " Clean up any involved entity
    ROLLBACK ENTITIES.

  ENDMETHOD.

  METHOD get_global_authorizations.
    DATA requested_authorizations TYPE STRUCTURE FOR GLOBAL AUTHORIZATION REQUEST ZPRA_MF_R_Visitor\\Visitor.
    DATA result TYPE STRUCTURE FOR GLOBAL AUTHORIZATION RESULT ZPRA_MF_R_Visitor\\Visitor.

    requested_authorizations-%delete = if_abap_behv=>mk-on.

    class_under_test->get_global_authorizations(
        EXPORTING
            requested_authorizations = requested_authorizations
        CHANGING
            result   = result
            reported = ms_reported_early ).
    cl_abap_unit_assert=>assert_equals( EXPORTING act = result-%delete
                                                  exp = if_abap_behv=>auth-allowed ) .

    requested_authorizations-%create = if_abap_behv=>mk-on.

    class_under_test->get_global_authorizations(
        EXPORTING
            requested_authorizations = requested_authorizations
        CHANGING
            result   = result
            reported = ms_reported_early ).
    cl_abap_unit_assert=>assert_equals( EXPORTING act = result-%create
                                                  exp = if_abap_behv=>auth-allowed ) .

    requested_authorizations-%update = if_abap_behv=>mk-on.

    class_under_test->get_global_authorizations(
        EXPORTING
            requested_authorizations = requested_authorizations
        CHANGING
            result   = result
            reported = ms_reported_early ).
    cl_abap_unit_assert=>assert_equals( EXPORTING act = result-%update
                                                  exp = if_abap_behv=>auth-allowed ) .
  ENDMETHOD.

  METHOD get_instance_authorizations.


    DATA entity_keys TYPE TABLE FOR AUTHORIZATION KEY ZPRA_MF_R_Visitor\\Visitor.
    DATA requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST ZPRA_MF_R_Visitor\\Visitor.
    DATA result TYPE TABLE FOR AUTHORIZATION RESULT ZPRA_MF_R_Visitor\\Visitor.
" Define mock visitor data with a known UUID
    DATA visitor_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.

    DATA(mock_uuid) = '3A959FF37AC81FE0A3DF859190FA47DB'.

    APPEND VALUE #( uuid = mock_uuid ) TO visitor_data.


" Insert mock data for the CDS view entity
    cds_test_environment->insert_test_data( i_data = visitor_data ).

    entity_keys = VALUE #( (  uuid = mock_uuid ) ).
    " specify test entity keys

    requested_authorizations-%update = if_abap_behv=>mk-on.

    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = entity_keys
        requested_authorizations = requested_authorizations
      CHANGING
        result                   = result
        failed                   = ms_failed_early
        reported                 = ms_reported_early
    ).
    cl_abap_unit_assert=>assert_initial( result ).

    requested_authorizations-%update = if_abap_behv=>mk-off.
    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = entity_keys
        requested_authorizations = requested_authorizations
      CHANGING
        result                   = result
        failed                   = ms_failed_early
        reported                 = ms_reported_early
    ).
    cl_abap_unit_assert=>assert_initial( result ).

    CLEAR : mock_uuid.
    mock_uuid = '3A959FF37AC81FE0A3DF859190FA47DZ'.
    cds_test_environment->insert_test_data( i_data = visitor_data ).

    entity_keys = VALUE #( (  uuid = mock_uuid ) ).
    requested_authorizations-%update = if_abap_behv=>mk-on.

    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = entity_keys
        requested_authorizations = requested_authorizations
      CHANGING
        result                   = result
        failed                   = ms_failed_early
        reported                 = ms_reported_early
    ).
    cl_abap_unit_assert=>assert_initial( result ).
  ENDMETHOD.

ENDCLASS.
