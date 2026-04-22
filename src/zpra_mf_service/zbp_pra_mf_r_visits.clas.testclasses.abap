
*"* use this source file for your ABAP unit test classes
CLASS ltcl_methods DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO lhc_ZPRA_MF_BP_R_Visits.  " the class to be tested
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
    METHODS determineStatus              FOR TESTING RAISING cx_static_check.
    METHODS determineAvailableSeats      FOR TESTING RAISING cx_static_check.
    METHODS actionBook                   FOR TESTING RAISING cx_static_check.
    METHODS actionCancel                 FOR TESTING RAISING cx_static_check.

    METHODS instanceFeatsActiveBooked    FOR TESTING RAISING cx_static_check.
    METHODS instanceFeatsActiveCancelled FOR TESTING RAISING cx_static_check.
    METHODS instanceFeatsActivePending   FOR TESTING RAISING cx_static_check.
    METHODS bookNoMatchingVisit          FOR TESTING RAISING cx_static_check.
    METHODS cancelNoMatchingVisit        FOR TESTING RAISING cx_static_check.
    METHODS determineStatusAlreadySet    FOR TESTING RAISING cx_static_check.
    METHODS detAvailSeatsOnlyPending     FOR TESTING RAISING cx_static_check.
    METHODS globalAuth                   FOR TESTING RAISING cx_static_check.
    METHODS instanceAuth                 FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_methods IMPLEMENTATION.
  METHOD class_setup.
    " Create the class under Test
    " The class is abstract but can be constructed with the FOR TESTING
    CREATE OBJECT class_under_test FOR TESTING.
    " Create test doubles for database dependencies
    " The EML READ operation will then also access the test doubles
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                               i_for_entities = VALUE #( ( i_for_entity = 'ZPRA_MF_R_MUSICFESTIVAL' )
                                                         ( i_for_entity = 'ZPRA_MF_R_VISITOR' )
                                                         ( i_for_entity = 'ZPRA_MF_R_VISIT' ) ) ).
    cds_test_environment->enable_double_redirection( ).
    sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'zpra_mf_d_mf' )
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
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).

    mf_mock_data = VALUE #( ( uuid                = 'DEC190889AC21FE08191A45962D04217'
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = 2
                              free_visitor_seats  = 2 ) ).

    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>booked ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported           TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA entity_keys        TYPE STANDARD TABLE OF ty_entity_key.
    DATA parent_entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " specify test parent entity keys
    parent_entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    " execute the determination
    class_under_test->determineAvailableSeats( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                               CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( msg = 'reported'
                                         act = reported ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( Uuid FreeVisitorSeats ) WITH CORRESPONDING #( parent_entity_keys )
         RESULT DATA(lt_read_freevisitorseats).

    " expect input keys and output keys to be same
    DATA exp LIKE lt_read_freevisitorseats.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04217' FreeVisitorSeats = 1 ) ).

    " current result; copy only fields of interest
    DATA act LIKE lt_read_freevisitorseats.

    act = CORRESPONDING #( lt_read_freevisitorseats MAPPING Uuid = Uuid
                                 FreeVisitorSeats = FreeVisitorSeats
                                EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act
                                        msg = 'Determination for Create Visitor - Available Seats' ).
  ENDMETHOD.

  METHOD determineStatus.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).

    vst_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04210' parent_uuid = 'DEC190889AC21FE08191A45962D04217' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported    TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04210' ) ).

    " execute the determination
    class_under_test->determineStatus( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                       CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( msg = 'reported'
                                         act = reported ).

    " Read the visit details
    DATA read_visitor_seats TYPE TABLE FOR READ RESULT zpra_mf_r_visit.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT read_visitor_seats.

    " expect input keys and output keys to be same
    DATA exp LIKE read_visitor_seats.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04210' Status = zcl_pra_mf_enum_visit_status=>pending ) ).

    " current result; copy only fields of interest
    DATA act LIKE read_visitor_seats.

    act = CORRESPONDING #( read_visitor_seats MAPPING Uuid = Uuid
                                 Status = Status
                                EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act
                                        msg = 'Determination result - Booked Status' ).
  ENDMETHOD.

  METHOD actionBook.
    DATA mf_mock_data         TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data       TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data        TYPE STANDARD TABLE OF zpra_mf_a_vst.
    DATA mf_mock_draft_data   TYPE STANDARD TABLE OF zpra_mf_d_mf.
    DATA vstr_mock_draft_data TYPE STANDARD TABLE OF zpra_mf_d_vstr.
    DATA vst_mock_draft_data  TYPE STANDARD TABLE OF zpra_mf_d_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).

    mf_mock_data = VALUE #( ( uuid                = 'DEC190889AC21FE08191A45962D04217'
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = 2
                              free_visitor_seats  = 1 ) ).

    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>cancelled ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    vstr_mock_draft_data = VALUE #(
        ( HasActiveEntity = '' DraftAdministrativeDataUUID = 'DEC190889AC21FE08191A45962D04311' Uuid = 'DEC190889AC21FE08191A45962D04210' Name = 'visitor1' ) ).

    mf_mock_draft_data = VALUE #( ( hasactiveentity             = ''
                                    draftadministrativedatauuid = 'DEC190889AC21FE08191A45962D04312'
                                    uuid                        = 'DEC190889AC21FE08191A45962D04217'
                                    eventdatetime               = '2028-01-01T00:00:00.0000000'
                                    title                       = 'Event 1'
                                    maxvisitorsnumber           = 2
                                    freevisitorseats            = 1 ) ).

    vst_mock_draft_data = VALUE #( ( hasactiveentity             = ''
                                     draftadministrativedatauuid = 'DEC190889AC21FE08191A45962D04313'
                                     uuid                        = 'DEC190889AC21FE08191A45962D04211'
                                     parentuuid                  = 'DEC190889AC21FE08191A45962D04217'
                                     visitoruuid                 = 'DEC190889AC21FE08191A45962D04210'
                                     status                      = zcl_pra_mf_enum_visit_status=>cancelled ) ).

    sql_test_environment->insert_test_data( i_data = mf_mock_draft_data ).
    sql_test_environment->insert_test_data( i_data = vst_mock_draft_data ).
    sql_test_environment->insert_test_data( i_data = vstr_mock_draft_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->Book( EXPORTING keys     = CORRESPONDING #( entity_keys )
                            CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( msg = 'reported'
                                         act = reported ).

    " Read the visit details
    DATA read_visitor_seats TYPE TABLE FOR READ RESULT zpra_mf_r_visit.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT read_visitor_seats.

    " expect input keys and output keys to be same
    DATA exp LIKE read_visitor_seats.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04211' Status = zcl_pra_mf_enum_visit_status=>booked ) ).

    " current result; copy only fields of interest
    DATA act LIKE read_visitor_seats.

    act = CORRESPONDING #( read_visitor_seats MAPPING Uuid = Uuid
                                 Status = Status
                                EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act
                                        msg = 'Action result - Booked Status' ).
  ENDMETHOD.

  METHOD actionCancel.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).

    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>booked ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->Cancel( EXPORTING keys     = CORRESPONDING #( entity_keys )
                              CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( msg = 'reported'
                                         act = reported ).

    " Read the visit details
    DATA read_visitor_seats TYPE TABLE FOR READ RESULT zpra_mf_r_visit.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT read_visitor_seats.

    " expect input keys and output keys to be same
    DATA exp LIKE read_visitor_seats.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04211' Status = zcl_pra_mf_enum_visit_status=>cancelled ) ).

    " current result; copy only fields of interest
    DATA act LIKE read_visitor_seats.

    act = CORRESPONDING #( read_visitor_seats MAPPING Uuid = Uuid
                                 Status = Status
                                EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act
                                        msg = 'Action result - Cancel Status' ).
  ENDMETHOD.

  METHOD instanceFeatsActiveBooked.
    " active booked visit: book/cancel disabled (non-draft), delete disabled (booked)
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
    mf_mock_data = VALUE #( ( uuid                = 'DEC190889AC21FE08191A45962D04217'
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = 2
                              free_visitor_seats  = 1 ) ).
    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>booked ) ).

    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    DATA result             TYPE TABLE FOR INSTANCE FEATURES RESULT zpra_mf_r_musicfestival\\Visits.
    DATA failed             TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA requested_features TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST zpra_mf_r_musicfestival\\Visits.
    DATA keys               TYPE TABLE FOR INSTANCE FEATURES KEY zpra_mf_r_musicfestival\\Visits.

    APPEND VALUE #( uuid = 'DEC190889AC21FE08191A45962D04211' ) TO keys.

    class_under_test->get_instance_features( EXPORTING keys               = keys
                                                       requested_features = requested_features
                                             CHANGING  result             = result
                                                       failed             = failed ).

    cl_abap_unit_assert=>assert_not_initial( act = result ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-disabled
                                        act = result[ 1 ]-%action-book ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-disabled
                                        act = result[ 1 ]-%action-cancel ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-disabled
                                        act = result[ 1 ]-%delete ).
  ENDMETHOD.

  METHOD instanceFeatsActiveCancelled.
    " active cancelled visit: book/cancel disabled (non-draft), delete enabled (cancelled)
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
    mf_mock_data = VALUE #( ( uuid                = 'DEC190889AC21FE08191A45962D04217'
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = 2
                              free_visitor_seats  = 1 ) ).
    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>cancelled ) ).

    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    DATA result             TYPE TABLE FOR INSTANCE FEATURES RESULT zpra_mf_r_musicfestival\\Visits.
    DATA failed             TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA requested_features TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST zpra_mf_r_musicfestival\\Visits.
    DATA keys               TYPE TABLE FOR INSTANCE FEATURES KEY zpra_mf_r_musicfestival\\Visits.

    APPEND VALUE #( uuid = 'DEC190889AC21FE08191A45962D04211' ) TO keys.

    class_under_test->get_instance_features( EXPORTING keys               = keys
                                                       requested_features = requested_features
                                             CHANGING  result             = result
                                                       failed             = failed ).

    cl_abap_unit_assert=>assert_not_initial( act = result ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-disabled
                                        act = result[ 1 ]-%action-book ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-disabled
                                        act = result[ 1 ]-%action-cancel ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-enabled
                                        act = result[ 1 ]-%delete ).
  ENDMETHOD.

  METHOD instanceFeatsActivePending.
    " active pending visit: book/cancel disabled (non-draft), delete enabled (pending)
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
    mf_mock_data = VALUE #( ( uuid                = 'DEC190889AC21FE08191A45962D04217'
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = 2
                              free_visitor_seats  = 2 ) ).
    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>pending ) ).

    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    DATA result             TYPE TABLE FOR INSTANCE FEATURES RESULT zpra_mf_r_musicfestival\\Visits.
    DATA failed             TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA requested_features TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST zpra_mf_r_musicfestival\\Visits.
    DATA keys               TYPE TABLE FOR INSTANCE FEATURES KEY zpra_mf_r_musicfestival\\Visits.

    APPEND VALUE #( uuid = 'DEC190889AC21FE08191A45962D04211' ) TO keys.

    class_under_test->get_instance_features( EXPORTING keys               = keys
                                                       requested_features = requested_features
                                             CHANGING  result             = result
                                                       failed             = failed ).

    cl_abap_unit_assert=>assert_not_initial( act = result ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-disabled
                                        act = result[ 1 ]-%action-book ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-disabled
                                        act = result[ 1 ]-%action-cancel ).

    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>fc-o-enabled
                                        act = result[ 1 ]-%delete ).
  ENDMETHOD.

  METHOD bookNoMatchingVisit.
    " non-existent key: CHECK early return without side effects
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    entity_keys = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04299' ) ).

    class_under_test->Book( EXPORTING keys     = CORRESPONDING #( entity_keys )
                            CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( act = reported ).
  ENDMETHOD.

  METHOD cancelNoMatchingVisit.
    " non-existent key: CHECK early return without side effects
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    entity_keys = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04299' ) ).

    class_under_test->Cancel( EXPORTING keys     = CORRESPONDING #( entity_keys )
                              CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( act = reported ).
  ENDMETHOD.

  METHOD determineStatusAlreadySet.
    " visit with existing status: filtered out by DELETE, CHECK exits early
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).
    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>booked ) ).

    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported    TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    entity_keys = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    class_under_test->determineStatus( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                       CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( act = reported ).

    " status must remain booked (determination skips visits with existing status)
    DATA read_result TYPE TABLE FOR READ RESULT zpra_mf_r_visit.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT read_result.

    DATA act LIKE read_result.
    act = CORRESPONDING #( read_result MAPPING Uuid = Uuid Status = Status EXCEPT * ).

    DATA exp LIKE read_result.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04211' Status = zcl_pra_mf_enum_visit_status=>booked ) ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act ).
  ENDMETHOD.

  METHOD detAvailSeatsOnlyPending.
    " only pending visits: all filtered out by DELETE, CHECK exits early
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
    mf_mock_data = VALUE #( ( uuid                = 'DEC190889AC21FE08191A45962D04217'
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = 2
                              free_visitor_seats  = 2 ) ).
    vst_mock_data = VALUE #( ( uuid         = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid  = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid = 'DEC190889AC21FE08191A45962D04210'
                               status       = zcl_pra_mf_enum_visit_status=>pending ) ).

    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported           TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA entity_keys        TYPE STANDARD TABLE OF ty_entity_key.
    DATA parent_entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    entity_keys = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' ) ).
    parent_entity_keys = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    class_under_test->determineAvailableSeats( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                               CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( act = reported ).

    " FreeVisitorSeats must remain unchanged (determination skips pending-only visits)
    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( Uuid FreeVisitorSeats ) WITH CORRESPONDING #( parent_entity_keys )
         RESULT DATA(read_result).

    DATA act LIKE read_result.
    act = CORRESPONDING #( read_result MAPPING Uuid = Uuid FreeVisitorSeats = FreeVisitorSeats EXCEPT * ).

    DATA exp LIKE read_result.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04217' FreeVisitorSeats = 2 ) ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act ).
  ENDMETHOD.

  METHOD globalAuth.
    " empty implementation: covers the no-op authorization method
    DATA requested TYPE STRUCTURE FOR GLOBAL AUTHORIZATION REQUEST zpra_mf_r_musicfestival\\Visits.
    DATA result    TYPE STRUCTURE FOR GLOBAL AUTHORIZATION RESULT zpra_mf_r_musicfestival\\Visits.
    DATA reported  TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.

    class_under_test->get_global_authorizations( EXPORTING requested_authorizations = requested
                                                 CHANGING  result                   = result
                                                           reported                 = reported ).

    cl_abap_unit_assert=>assert_initial( act = result ).
  ENDMETHOD.

  METHOD instanceAuth.
    " empty implementation: covers the no-op authorization method
    DATA keys      TYPE TABLE FOR AUTHORIZATION KEY zpra_mf_r_musicfestival\\Visits.
    DATA requested TYPE STRUCTURE FOR AUTHORIZATION REQUEST zpra_mf_r_musicfestival\\Visits.
    DATA result    TYPE TABLE FOR AUTHORIZATION RESULT zpra_mf_r_musicfestival\\Visits.
    DATA reported  TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.

    APPEND VALUE #( uuid = 'DEC190889AC21FE08191A45962D04211' ) TO keys.

    class_under_test->get_instance_authorizations( EXPORTING keys                     = keys
                                                             requested_authorizations = requested
                                                   CHANGING  result                   = result
                                                             reported                 = reported ).

    cl_abap_unit_assert=>assert_initial( act = result ).
  ENDMETHOD.
ENDCLASS.
