
*"* use this source file for your ABAP unit test classes
CLASS ltcl_methods DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_ZPRA_MF_BP_R_Visits,               " the class to be tested
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
      determineStatus         FOR TESTING RAISING cx_static_check,
      determineAvailableSeats FOR TESTING RAISING cx_static_check,
      actionBook              FOR TESTING RAISING cx_static_check,
      actionCancel            FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_methods IMPLEMENTATION.

  METHOD class_setup.
    " Create the class under Test
    " The class is abstract but can be constructed with the FOR TESTING
    CREATE OBJECT class_under_test FOR TESTING.
    " Create test doubles for database dependencies
    " The EML READ operation will then also access the test doubles
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds( i_for_entities = VALUE #(
        ( i_for_entity = 'ZPRA_MF_R_MUSICFESTIVAL' )
        ( i_for_entity = 'ZPRA_MF_R_VISITOR' )
        ( i_for_entity = 'ZPRA_MF_R_VISIT' ) ) ).
    cds_test_environment->enable_double_redirection( ).
    sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #(
        ( 'zpra_mf_d_mf' )
        ( 'zpra_mf_d_vst' )
        ( 'zpra_mf_d_vstr' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    " stop mocking
    cds_test_environment->destroy( ).
    sql_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    " clear the content of the test double per test
    cds_test_environment->clear_doubles( ).
    sql_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    " Clean up any involved entity
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD determineAvailableSeats.
*    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
*    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
*    DATA vst_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vst.
*
*    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
*
*    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 2 ) ).
*
*    vst_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' parent_uuid = 'DEC190889AC21FE08191A45962D04217' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' ) ).
*
*    " insert test data into the cds test doubles
*    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).
*
*    " call the method to be tested
*    TYPES: BEGIN OF ty_entity_key,
*             uuid TYPE sysuuid_x16,
*           END OF ty_entity_key.
*
*    DATA: reported           TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival,
*          entity_keys        TYPE STANDARD TABLE OF ty_entity_key,
*          parent_entity_keys TYPE STANDARD TABLE OF ty_entity_key.
*
*    " specify test entity keys
*    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).
*
*    " specify test parent entity keys
*    parent_entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).
*
*    " execute the determination
*    class_under_test->determineAvailableSeats(
*      EXPORTING
*        keys     = CORRESPONDING #( entity_keys )
*      CHANGING
*        reported = reported
*    ).
*
*    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).
*
*    " additionally check by reading entity state
*    READ ENTITY zpra_mf_r_musicfestival
*    FIELDS ( Uuid FreeVisitorSeats ) WITH CORRESPONDING #( parent_entity_keys )
*    RESULT DATA(lt_read_freevisitorseats).
*
*    " expect input keys and output keys to be same
*    DATA exp LIKE lt_read_freevisitorseats.
*    exp = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04217' FreeVisitorSeats = 1 ) ).
*
*
*    " current result; copy only fields of interest
*    DATA act LIKE lt_read_freevisitorseats.
*
*    act = CORRESPONDING #( lt_read_freevisitorseats MAPPING Uuid = Uuid
*                                 FreeVisitorSeats      = FreeVisitorSeats
*                                EXCEPT * ).
*
*    cl_abap_unit_assert=>assert_equals( msg = 'Determination for Create Visitor - Available Seats' exp = exp act = act ).

  ENDMETHOD.

  METHOD determineStatus.
*    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
*    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
*    DATA vst_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vst.
*
*    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
*
*    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).
*
*    vst_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' parent_uuid = 'DEC190889AC21FE08191A45962D04217' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' ) ).
*
*    " insert test data into the cds test doubles
*    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).
*
*    " call the method to be tested
*    TYPES: BEGIN OF ty_entity_key,
*             uuid TYPE sysuuid_x16,
*           END OF ty_entity_key.
*
*    DATA: reported    TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival,
*          entity_keys TYPE STANDARD TABLE OF ty_entity_key.
*
*    " specify test entity keys
*    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04210' ) ).
*
*    " execute the determination
*    class_under_test->determineStatus(
*      EXPORTING
*        keys     = CORRESPONDING #( entity_keys )
*      CHANGING
*        reported = reported
*    ).
*
*    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).
*
*    " Read the visit details
*    DATA: lt_read_visitor_seats TYPE TABLE FOR READ RESULT zpra_mf_r_visit.
*    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
*      ENTITY Visits
*         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
*      RESULT lt_read_visitor_seats.
*
*    " expect input keys and output keys to be same
*    DATA exp LIKE lt_read_visitor_seats.
*    exp = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04210' Status = 'B' ) ).
*
*
*    " current result; copy only fields of interest
*    DATA act LIKE lt_read_visitor_seats.
*
*    act = CORRESPONDING #( lt_read_visitor_seats MAPPING Uuid = Uuid
*                                 Status      = Status
*                                EXCEPT * ).
*
*    cl_abap_unit_assert=>assert_equals( msg = 'Determination result - Booked Status' exp = exp act = act ).

  ENDMETHOD.

  METHOD actionBook.
*    DATA: mf_mock_data         TYPE STANDARD TABLE OF zpra_mf_a_mf,
*          vstr_mock_data       TYPE STANDARD TABLE OF zpra_mf_a_vstr,
*          vst_mock_data        TYPE STANDARD TABLE OF zpra_mf_a_vst,
*          mf_mock_draft_data   TYPE STANDARD TABLE OF zpra_mf_d_mf,
*          vstr_mock_draft_data TYPE STANDARD TABLE OF zpra_mf_d_vstr,
*          vst_mock_draft_data  TYPE STANDARD TABLE OF zpra_mf_d_vst.
*
*    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
*
*    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 1 ) ).
*
*    vst_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' parent_uuid = 'DEC190889AC21FE08191A45962D04217' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' status = 'C' ) ).
*
*    " insert test data into the cds test doubles
*    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).
*
*    vstr_mock_draft_data = VALUE #( ( hasactiveentity = '' draftadministrativedatauuid = 'DEC190889AC21FE08191A45962D04311' uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
*
*    mf_mock_draft_data = VALUE #( ( hasactiveentity = '' draftadministrativedatauuid = 'DEC190889AC21FE08191A45962D04312' uuid = 'DEC190889AC21FE08191A45962D04217' eventdatetime = '2028-01-01T00:00:00.0000000' title = 'Event 1' maxvisitorsnumber = 2
*freevisitorseats = 1 ) ).
*
*    vst_mock_draft_data = VALUE #( ( hasactiveentity = '' draftadministrativedatauuid = 'DEC190889AC21FE08191A45962D04313' uuid = 'DEC190889AC21FE08191A45962D04211' parentuuid = 'DEC190889AC21FE08191A45962D04217' visitoruuid =
*'DEC190889AC21FE08191A45962D04210' status = 'C' ) ).
*
*    sql_test_environment->insert_test_data( i_data = mf_mock_draft_data ).
*    sql_test_environment->insert_test_data( i_data = vst_mock_draft_data ).
*    sql_test_environment->insert_test_data( i_data = vstr_mock_draft_data ).
*
*    " call the method to be tested
*    TYPES: BEGIN OF ty_entity_key,
*             uuid TYPE sysuuid_x16,
*           END OF ty_entity_key.
*
*    DATA: reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival,
*          entity_keys TYPE STANDARD TABLE OF ty_entity_key.
*
*    " specify test entity keys
*    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).
*
*    " execute the action
*    class_under_test->Book(
*      EXPORTING
*        keys     = CORRESPONDING #( entity_keys )
*      CHANGING
*        reported = reported
*    ).
*
*    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).
*
*    " Read the visit details
*    DATA: lt_read_visitor_seats TYPE TABLE FOR READ RESULT zpra_mf_r_visit.
*    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
*      ENTITY Visits
*         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
*      RESULT lt_read_visitor_seats.
*
*    " expect input keys and output keys to be same
*    DATA exp LIKE lt_read_visitor_seats.
*    exp = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04211' Status = 'B' ) ).
*
*
*    " current result; copy only fields of interest
*    DATA act LIKE lt_read_visitor_seats.
*
*    act = CORRESPONDING #( lt_read_visitor_seats MAPPING Uuid = Uuid
*                                 Status      = Status
*                                EXCEPT * ).
*
*    cl_abap_unit_assert=>assert_equals( msg = 'Action result - Booked Status' exp = exp act = act ).

  ENDMETHOD.

  METHOD actionCancel.
*    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
*    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
*    DATA vst_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vst.
*
*    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
*
*    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).
*
*    vst_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' parent_uuid = 'DEC190889AC21FE08191A45962D04217' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' status = 'B' ) ).
*
*    " insert test data into the cds test doubles
*    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
*    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).
*
*    " call the method to be tested
*    TYPES: BEGIN OF ty_entity_key,
*             uuid TYPE sysuuid_x16,
*           END OF ty_entity_key.
*
*    DATA: reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival,
*          entity_keys TYPE STANDARD TABLE OF ty_entity_key.
*
*    " specify test entity keys
*    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).
*
*    " execute the action
*    class_under_test->Cancel(
*      EXPORTING
*        keys     = CORRESPONDING #( entity_keys )
*      CHANGING
*        reported = reported
*    ).
*
*    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).
*
*    " Read the visit details
*    DATA: lt_read_visitor_seats TYPE TABLE FOR READ RESULT zpra_mf_r_visit.
*    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
*      ENTITY Visits
*         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
*      RESULT lt_read_visitor_seats.
*
*    " expect input keys and output keys to be same
*    DATA exp LIKE lt_read_visitor_seats.
*    exp = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04211' Status = 'C' ) ).
*
*
*    " current result; copy only fields of interest
*    DATA act LIKE lt_read_visitor_seats.
*
*    act = CORRESPONDING #( lt_read_visitor_seats MAPPING Uuid = Uuid
*                                 Status      = Status
*                                EXCEPT * ).
*
*    cl_abap_unit_assert=>assert_equals( msg = 'Action result - Cancel Status' exp = exp act = act ).
  ENDMETHOD.

ENDCLASS.
