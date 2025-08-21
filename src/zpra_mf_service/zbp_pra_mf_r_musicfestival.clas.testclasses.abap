*"* use this source file for your ABAP unit test classes
**************************************************************
*  Local class to test validations in behavior implementations         *
**************************************************************
"! @testing BDEF:ZPRA_MF_R_MUSICFESTIVAL
CLASS ltc_validation_methods DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival,               " the class to be tested
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

      validateDate            FOR TESTING,
      validateMandatoryValue  FOR TESTING,
      validateMaxVisitors     FOR TESTING.

ENDCLASS.


CLASS ltc_validation_methods IMPLEMENTATION.


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

  METHOD validateDate.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA: failed      TYPE RESPONSE FOR FAILED LATE ZPRA_MF_R_MusicFestival,
          reported    TYPE RESPONSE FOR REPORTED LATE ZPRA_MF_R_MusicFestival,
          entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2025-01-01T00:00:00.0000000' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04218' event_date_time = '2028-01-01T00:00:00.0000000' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218' ) ).

    " execute the validation
    class_under_test->validateDate(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Expect no failures and messages for the valid event date
    cl_abap_unit_assert=>assert_initial( msg = 'failed' act = failed ).
    " As it a valid future date, expect the event to be returned
    cl_abap_unit_assert=>assert_not_initial( msg = 'reported' act = reported ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).


    " execute the validation
    class_under_test->validateDate(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check the validation message for past event date
    cl_abap_unit_assert=>assert_not_initial( msg = 'Failed' act = failed ).
    cl_abap_unit_assert=>assert_equals( msg = 'Failed Uuid' act = failed-musicfestival[ 1 ]-Uuid exp = 'DEC190889AC21FE08191A45962D04217' ).
    cl_abap_unit_assert=>assert_equals( act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key
                                        exp = zcm_pra_mf_messages=>event_datetime_invalid ).

  ENDMETHOD.

  METHOD validateMandatoryValue.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA: failed      TYPE RESPONSE FOR FAILED LATE ZPRA_MF_R_MusicFestival,
          reported    TYPE RESPONSE FOR REPORTED LATE ZPRA_MF_R_MusicFestival,
          entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = '10' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04218' event_date_time = '2028-01-01T00:00:00.0000000' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).


    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    " execute the validation
    class_under_test->validateMandatoryValue(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Expect no failures and messages
    cl_abap_unit_assert=>assert_initial( msg = 'failed' act = failed ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'reported' act = reported ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218' ) ).


    " execute the validation
    class_under_test->validateMandatoryValue(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check the validation message for missing mandatory fields
    cl_abap_unit_assert=>assert_not_initial( failed ).
    cl_abap_unit_assert=>assert_equals( act = failed-musicfestival[ 1 ]-Uuid
                                        exp = 'DEC190889AC21FE08191A45962D04218' ).
    cl_abap_unit_assert=>assert_equals( act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key
                                        exp = zcm_pra_mf_messages=>event_mandatory_value_missing ).

  ENDMETHOD.

  METHOD validateMaxVisitors.

    DATA: mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf,
          vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr,
          vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.
    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA: failed      TYPE RESPONSE FOR FAILED LATE ZPRA_MF_R_MusicFestival,
          reported    TYPE RESPONSE FOR REPORTED LATE ZPRA_MF_R_MusicFestival,
          entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' )
                              ( uuid = 'DEC190889AC21FE08191A45962D04211' name = 'visitor2' )
                              ( uuid = 'DEC190889AC21FE08191A45962D04212' name = 'visitor3' ) ).

    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 0 )
                            ( uuid = 'DEC190889AC21FE08191A45962D04218' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 2' max_visitors_number = '2' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04219' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 3' max_visitors_number = '4' ) ).

    vst_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04213' parent_uuid = 'DEC190889AC21FE08191A45962D04218' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' status = 'B' )
                             ( uuid = 'DEC190889AC21FE08191A45962D04214' parent_uuid = 'DEC190889AC21FE08191A45962D04218' visitor_uuid = 'DEC190889AC21FE08191A45962D04211' status = 'B' )
                             ( uuid = 'DEC190889AC21FE08191A45962D04215' parent_uuid = 'DEC190889AC21FE08191A45962D04218' visitor_uuid = 'DEC190889AC21FE08191A45962D04212' status = 'B' )
                             ( uuid = 'DEC190889AC21FE08191A45962D04223' parent_uuid = 'DEC190889AC21FE08191A45962D04219' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' status = 'B' )
                             ( uuid = 'DEC190889AC21FE08191A45962D04224' parent_uuid = 'DEC190889AC21FE08191A45962D04219' visitor_uuid = 'DEC190889AC21FE08191A45962D04211' status = 'B' )
                             ( uuid = 'DEC190889AC21FE08191A45962D04225' parent_uuid = 'DEC190889AC21FE08191A45962D04219' visitor_uuid = 'DEC190889AC21FE08191A45962D04212' status = 'B' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).


    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04219' ) ).

    " execute the validation
    class_under_test->validateMaxVisitors(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Expect no failures and messages
    cl_abap_unit_assert=>assert_initial( msg = 'failed' act = failed ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'reported' act = reported ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218' ) ).


    " execute the validation
    class_under_test->validateMaxVisitors(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        failed   = failed
        reported = reported
    ).
    " Check the validation message for maximum number of visitors
    cl_abap_unit_assert=>assert_not_initial( msg = 'failed' act = failed ).
    cl_abap_unit_assert=>assert_equals( msg = 'Failed Uuid' act = failed-musicfestival[ 1 ]-Uuid exp = 'DEC190889AC21FE08191A45962D04218' ).
    cl_abap_unit_assert=>assert_equals( act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key
                                        exp = zcm_pra_mf_messages=>max_visitors_less_than_booked ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).


    " execute the validation
    class_under_test->validateMaxVisitors(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check the validation message for negative or zero for maximum visitors
    cl_abap_unit_assert=>assert_not_initial( failed ).
    cl_abap_unit_assert=>assert_equals( act = failed-musicfestival[ 2 ]-Uuid
                                        exp = 'DEC190889AC21FE08191A45962D04217' ).
    cl_abap_unit_assert=>assert_equals( act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key
                                        exp = zcm_pra_mf_messages=>max_visitors_less_than_booked ).

  ENDMETHOD.


ENDCLASS.

**************************************************************
*  Local class to test actions in behavior implementations   *
**************************************************************
"! @testing BDEF:ZPRA_MF_R_MUSICFESTIVAL
CLASS ltc_action_methods DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival,               " the class to be tested
      cds_test_environment TYPE REF TO if_cds_test_environment.  " cds test double framework

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

      publish        FOR TESTING RAISING cx_static_check,
      cancel         FOR TESTING RAISING cx_static_check,
      generate_data  FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_action_methods IMPLEMENTATION.

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

  ENDMETHOD.

  METHOD class_teardown.
    " stop mocking
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    " clear the content of the test double per test
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    " Clean up any involved entity
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD publish.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 0 status = 'I' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04212' title = 'Event 2' max_visitors_number = 2 free_visitor_seats = 1 status = 'I' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04213' title = 'Event 3' max_visitors_number = 4 free_visitor_seats = 0 status = 'F' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.


    DATA: result      TYPE TABLE    FOR ACTION RESULT zpra_mf_r_musicfestival\\MusicFestival~publish,
          mapped      TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival,
          failed      TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival,
          reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival,
          entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->publish(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        result   = result
        mapped   = mapped
        failed   = failed
        reported = reported
    ).

    " expect input keys and output keys to be same and Status
    DATA exp LIKE result.
    exp = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04211'  %param-Status = 'F' ) ).


    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act_fb LIKE result.

    act_fb = CORRESPONDING #( result MAPPING Uuid = Uuid
                                (  %param = %param MAPPING Status      = Status
                                EXCEPT * )
                            EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( msg = 'Action Publish - Status - Fully Booked' exp = exp act = act_fb ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
    FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
    RESULT DATA(read_result).

    act_fb = VALUE #( FOR t IN read_result ( Uuid          = t-Uuid
                                             %param-Status = t-Status ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'Action Publish - Status - Fully Booked - Read result' exp = exp act = act_fb ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04212' ) ).

    " execute the action
    class_under_test->publish(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        result   = result
        mapped   = mapped
        failed   = failed
        reported = reported
    ).

    " expect input keys and output keys to be same and Status
    DATA exp_publish LIKE result.
    exp_publish = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04212'  %param-Status = 'P' ) ).


    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act_publish LIKE result.

    act_publish = CORRESPONDING #( result MAPPING Uuid = Uuid
                                (  %param = %param MAPPING Status      = Status
                                EXCEPT * )
                            EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( msg = 'Action Publish - Status - Published' exp = exp_publish act = act_publish ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
    FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
    RESULT DATA(read_result_publish).

    act_publish = VALUE #( FOR t IN read_result_publish ( Uuid          = t-Uuid
                                                          %param-Status = t-Status ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'Action Publish - Status - Published - Read result' exp = exp_publish act = act_publish ).


  ENDMETHOD.

  METHOD cancel.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 0 status = 'I' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.


    DATA: result      TYPE TABLE    FOR ACTION RESULT zpra_mf_r_musicfestival\\MusicFestival~cancel,
          mapped      TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival,
          failed      TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival,
          reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival,
          entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->cancel(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        result   = result
        mapped   = mapped
        failed   = failed
        reported = reported
    ).


    " expect input keys and output keys to be same and Status
    DATA exp LIKE result.
    exp = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04211'  %param-Status = 'C' ) ).


    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act LIKE result.

    act = CORRESPONDING #( result MAPPING Uuid = Uuid
                                (  %param = %param MAPPING Status      = Status
                                EXCEPT * )
                            EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( msg = 'Action Cancel - Status - Cancel' exp = exp act = act ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
    FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
    RESULT DATA(read_result).

    act = VALUE #( FOR t IN read_result ( Uuid          = t-Uuid
                                          %param-Status = t-Status ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'Action Cancel - Status - Cancel - Read result' exp = exp act = act ).

  ENDMETHOD.

  METHOD generate_data.

 TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.


    DATA: entity_keys TYPE STANDARD TABLE OF ty_entity_key,
          lt_action  TYPE TABLE FOR ACTION IMPORT ZPRA_MF_R_MusicFestival~generateSampleData.

  lt_action = VALUE #( ( %cid = 'Root1' ) ).
  entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).


  MODIFY ENTITY zpra_mf_r_musicfestival
    EXECUTE generatesampledata FROM lt_action
    MAPPED   DATA(mapped_generate_sample_data)
    FAILED   DATA(failed_generate_sample_data)
    REPORTED DATA(reported_generate_sample_data).


    DATA(lv_visitor_count) = lines( mapped_generate_sample_data-visits ).
    DATA(lv_music_fest_count) = lines( mapped_generate_sample_data-musicfestival ).
*
    cl_abap_unit_assert=>assert_equals( msg = 'Action Generate Sample Data - Visitor count'  exp = 8  act = lv_visitor_count ).
    cl_abap_unit_assert=>assert_equals( msg = 'Action Generate Sample Data - Music Festival count'  exp = 5  act = lv_music_fest_count ).
  ENDMETHOD.

ENDCLASS.

**************************************************************
*  Local class to test determinations in behavior implementations   *
**************************************************************
"! @testing BDEF:ZPRA_MF_R_MUSICFESTIVAL
CLASS ltcl_determination_methods DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival,               " the class to be tested
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

      determineStatus          FOR TESTING RAISING cx_static_check,
      determineAvailableSeats  FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_determination_methods IMPLEMENTATION.

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

  METHOD determineStatus.

    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 2 )
                            ( uuid = 'DEC190889AC21FE08191A45962D04212' title = 'Event 2' max_visitors_number = 2 free_visitor_seats = 0 status = 'P' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04213' title = 'Event 3' max_visitors_number = 4 free_visitor_seats = 2 status = 'F' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.


    DATA: reported    TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival,
          entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the determination
    class_under_test->determineStatus(
      EXPORTING
        keys     = CORRESPONDING #( entity_keys )
      CHANGING
        reported = reported
    ).

    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
    FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
    RESULT DATA(lt_read_status).


    " expect input keys and output keys to be same and Status
    DATA exp_inprogress LIKE lt_read_status.
    exp_inprogress = VALUE #(  ( Uuid = 'DEC190889AC21FE08191A45962D04211' Status = 'I' ) ).


    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act_inprogress LIKE lt_read_status.

    act_inprogress = CORRESPONDING #( lt_read_status MAPPING Uuid = Uuid
                                 Status      = Status
                                EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( msg = 'Status Determination - Status - In Progress' exp = exp_inprogress act = act_inprogress ).

  ENDMETHOD.

  METHOD determineAvailableSeats.

    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA: reported             TYPE RESPONSE FOR REPORTED  zpra_mf_r_musicfestival,
          failed               TYPE RESPONSE FOR FAILED  zpra_mf_r_musicfestival,
          mapped               TYPE RESPONSE FOR MAPPED  zpra_mf_r_musicfestival,
          lt_music_festival TYPE TABLE FOR READ RESULT  zpra_mf_r_musicfestival,
          entity_keys          TYPE STANDARD TABLE OF ty_entity_key.

    MODIFY ENTITIES OF zpra_mf_r_musicfestival
     ENTITY MusicFestival
       CREATE SET FIELDS WITH
         VALUE #(     ( %cid              = 'ROOT1'
                        MaxVisitorsNumber = 2
                        FreeVisitorSeats  = 0
                  ) )
       CREATE BY \_Visits SET FIELDS WITH
         VALUE #(     ( %cid_ref          = 'ROOT1'
                        %target           = VALUE #( (
                                     %cid        = 'VISITS1'
                                     VisitorUuid = 'DEC190889AC21FE08191A45962D04210'

                                     ) )
                  ) )
       ENTITY Visits
        EXECUTE book
        FROM VALUE #( ( %cid_ref          = 'VISITS1' ) )

        MAPPED mapped
        FAILED failed
        REPORTED reported.


    LOOP AT mapped-musicfestival ASSIGNING FIELD-SYMBOL(<fs_mapped>).
      entity_keys = VALUE #( (  uuid =  <fs_mapped>-uuid ) ).

      READ ENTITIES OF zpra_mf_r_musicfestival IN LOCAL MODE
      ENTITY MusicFestival
      FIELDS ( FreeVisitorSeats )
      WITH CORRESPONDING #( entity_keys )
      RESULT lt_music_festival.
    ENDLOOP.
    READ TABLE lt_music_festival ASSIGNING FIELD-SYMBOL(<ls_music_festival>) INDEX 1.
    cl_abap_unit_assert=>assert_equals( msg = 'Free Seats calculated for an event' exp = 1 act = <ls_music_festival>-FreeVisitorSeats ).
  ENDMETHOD.


ENDCLASS.
**************************************************************
*  Local class to test validations in behavior implementations         *
**************************************************************
"! @testing BDEF:ZPRA_MF_R_MUSICFESTIVAL
CLASS ltc_authorization_methods DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival,               " the class to be tested
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

    TYPES s_reported_early TYPE RESPONSE FOR REPORTED EARLY ZPRA_MF_R_MusicFestival.
    TYPES s_failed_early TYPE RESPONSE FOR FAILED EARLY ZPRA_MF_R_MusicFestival.

    DATA : ms_reported_early TYPE s_reported_early.
    DATA : ms_failed_early   TYPE s_failed_early.
ENDCLASS.


CLASS ltc_authorization_methods IMPLEMENTATION.


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

  METHOD get_global_authorizations.
    DATA ls_requested_authorizations TYPE STRUCTURE FOR GLOBAL AUTHORIZATION REQUEST ZPRA_MF_R_MusicFestival\\MusicFestival.
    DATA lt_result TYPE STRUCTURE FOR GLOBAL AUTHORIZATION RESULT ZPRA_MF_R_MusicFestival\\MusicFestival.

    ls_requested_authorizations-%delete = if_abap_behv=>mk-on.

    class_under_test->get_global_authorizations(
        EXPORTING
            requested_authorizations = ls_requested_authorizations
        CHANGING
            result   = lt_result
            reported = ms_reported_early ).

  ENDMETHOD.

  METHOD get_instance_authorizations.


    DATA lt_entity_keys TYPE TABLE FOR AUTHORIZATION KEY ZPRA_MF_R_MusicFestival\\MusicFestival.
    DATA ls_requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST ZPRA_MF_R_MusicFestival\\MusicFestival.
    DATA lt_result TYPE TABLE FOR AUTHORIZATION RESULT ZPRA_MF_R_MusicFestival\\MusicFestival.

    " specify test entity keys
    lt_entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218' ) ).

    lt_result = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218'  ) ).

    class_under_test->get_instance_authorizations(
      EXPORTING
        keys                     = lt_entity_keys
        requested_authorizations = ls_requested_authorizations
      CHANGING
        result                   = lt_result
        failed                   = ms_failed_early
        reported                 = ms_reported_early
    ).
  ENDMETHOD.

ENDCLASS.
