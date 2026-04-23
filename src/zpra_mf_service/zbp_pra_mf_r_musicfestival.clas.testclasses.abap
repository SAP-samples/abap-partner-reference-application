" * use this source file for your ABAP unit test classes
" -------------------------------------------------------------
"   Local class to test validations in behavior implementations         -
" -------------------------------------------------------------
CLASS ltc_validation_methods DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival. " the class to be tested
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.     " cds test double framework

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.

    METHODS validateDate           FOR TESTING.
    METHODS validateMandatoryValue FOR TESTING.
    METHODS validateMaxVisitors    FOR TESTING.

ENDCLASS.


CLASS ltc_validation_methods IMPLEMENTATION.
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

  METHOD validateDate.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA failed      TYPE RESPONSE FOR FAILED LATE ZPRA_MF_R_MusicFestival.
    DATA reported    TYPE RESPONSE FOR REPORTED LATE ZPRA_MF_R_MusicFestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2025-01-01T00:00:00.0000000' )
        ( uuid = 'DEC190889AC21FE08191A45962D04218' event_date_time = '2028-01-01T00:00:00.0000000' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218' ) ).

    " execute the validation
    class_under_test->validateDate( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                    CHANGING  failed   = failed
                                              reported = reported ).

    " Expect no failures and messages for the valid event date
    cl_abap_unit_assert=>assert_initial( act = failed ).
    " As it a valid future date, expect the event to be returned
    cl_abap_unit_assert=>assert_not_initial( act = reported ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    " execute the validation
    class_under_test->validateDate( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                    CHANGING  failed   = failed
                                              reported = reported ).

    " Check the validation message for past event date
    cl_abap_unit_assert=>assert_not_initial( act = failed ).
    cl_abap_unit_assert=>assert_equals( exp = 'DEC190889AC21FE08191A45962D04217'
                                        act = failed-musicfestival[ 1 ]-Uuid ).
    cl_abap_unit_assert=>assert_equals( exp = zcm_pra_mf_messages=>event_datetime_invalid
                                        act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key ).
  ENDMETHOD.

  METHOD validateMandatoryValue.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA failed      TYPE RESPONSE FOR FAILED LATE ZPRA_MF_R_MusicFestival.
    DATA reported    TYPE RESPONSE FOR REPORTED LATE ZPRA_MF_R_MusicFestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    mf_mock_data = VALUE #( event_date_time = '2028-01-01T00:00:00.0000000'
                            ( uuid = 'DEC190889AC21FE08191A45962D04217' title = 'Event 1' max_visitors_number = '10' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04218' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    " execute the validation
    class_under_test->validateMandatoryValue( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                              CHANGING  failed   = failed
                                                        reported = reported ).

    " Expect no failures and messages
    cl_abap_unit_assert=>assert_initial( act = failed ).
    cl_abap_unit_assert=>assert_not_initial( act = reported ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218' ) ).

    " execute the validation
    class_under_test->validateMandatoryValue( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                              CHANGING  failed   = failed
                                                        reported = reported ).

    " Check the validation message for missing mandatory fields
    cl_abap_unit_assert=>assert_not_initial( failed ).
    cl_abap_unit_assert=>assert_equals( exp = 'DEC190889AC21FE08191A45962D04218'
                                        act = failed-musicfestival[ 1 ]-Uuid ).
    cl_abap_unit_assert=>assert_equals( exp = zcm_pra_mf_messages=>event_mandatory_value_missing
                                        act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key ).
  ENDMETHOD.

  METHOD validateMaxVisitors.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.
    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA failed      TYPE RESPONSE FOR FAILED LATE ZPRA_MF_R_MusicFestival.
    DATA reported    TYPE RESPONSE FOR REPORTED LATE ZPRA_MF_R_MusicFestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' )
                              ( uuid = 'DEC190889AC21FE08191A45962D04211' name = 'visitor2' )
                              ( uuid = 'DEC190889AC21FE08191A45962D04212' name = 'visitor3' ) ).

    mf_mock_data = VALUE #( event_date_time = '2028-01-01T00:00:00.0000000'
                            ( uuid = 'DEC190889AC21FE08191A45962D04217' title = 'Event 1' max_visitors_number = 0 )
                            ( uuid = 'DEC190889AC21FE08191A45962D04218' title = 'Event 2' max_visitors_number = '2' )
                            ( uuid = 'DEC190889AC21FE08191A45962D04219' title = 'Event 3' max_visitors_number = '4' ) ).

    vst_mock_data = VALUE #(
        status = 'B'
        ( uuid = 'DEC190889AC21FE08191A45962D04213' parent_uuid = 'DEC190889AC21FE08191A45962D04218' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' )
        ( uuid = 'DEC190889AC21FE08191A45962D04214' parent_uuid = 'DEC190889AC21FE08191A45962D04218' visitor_uuid = 'DEC190889AC21FE08191A45962D04211' )
        ( uuid = 'DEC190889AC21FE08191A45962D04215' parent_uuid = 'DEC190889AC21FE08191A45962D04218' visitor_uuid = 'DEC190889AC21FE08191A45962D04212' )
        ( uuid = 'DEC190889AC21FE08191A45962D04223' parent_uuid = 'DEC190889AC21FE08191A45962D04219' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' )
        ( uuid = 'DEC190889AC21FE08191A45962D04224' parent_uuid = 'DEC190889AC21FE08191A45962D04219' visitor_uuid = 'DEC190889AC21FE08191A45962D04211' )
        ( uuid = 'DEC190889AC21FE08191A45962D04225' parent_uuid = 'DEC190889AC21FE08191A45962D04219' visitor_uuid = 'DEC190889AC21FE08191A45962D04212' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04219' ) ).

    " execute the validation
    class_under_test->validateMaxVisitors( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                           CHANGING  failed   = failed
                                                     reported = reported ).

    " Expect no failures and messages
    cl_abap_unit_assert=>assert_initial( act = failed ).
    cl_abap_unit_assert=>assert_not_initial( act = reported ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04218' ) ).

    " execute the validation
    class_under_test->validateMaxVisitors( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                           CHANGING  failed   = failed
                                                     reported = reported ).
    " Check the validation message for maximum number of visitors
    cl_abap_unit_assert=>assert_not_initial( act = failed ).
    cl_abap_unit_assert=>assert_equals( exp = 'DEC190889AC21FE08191A45962D04218'
                                        act = failed-musicfestival[ 1 ]-Uuid ).
    cl_abap_unit_assert=>assert_equals( exp = zcm_pra_mf_messages=>max_visitors_less_than_booked
                                        act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    " execute the validation
    class_under_test->validateMaxVisitors( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                           CHANGING  failed   = failed
                                                     reported = reported ).

    " Check the validation message for negative or zero for maximum visitors
    cl_abap_unit_assert=>assert_not_initial( failed ).
    cl_abap_unit_assert=>assert_equals( exp = 'DEC190889AC21FE08191A45962D04217'
                                        act = failed-musicfestival[ 2 ]-Uuid ).
    cl_abap_unit_assert=>assert_equals( exp = zcm_pra_mf_messages=>max_visitors_less_than_booked
                                        act = reported-musicfestival[ 3 ]-%msg->if_t100_message~t100key ).
  ENDMETHOD.
ENDCLASS.

" -------------------------------------------------------------
" Local class to test actions in behavior implementations   -
" -------------------------------------------------------------
CLASS zbp_pra_mf_r_musicfestival DEFINITION LOCAL FRIENDS ltc_action_methods.
CLASS zbp_pra_mf_r_musicfestival DEFINITION LOCAL FRIENDS ltc_saver_methods.

CLASS ltc_action_methods DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival. " the class to be tested
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.     " cds test double framework

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.

    METHODS publish                   FOR TESTING RAISING cx_static_check.
    METHODS cancel                    FOR TESTING RAISING cx_static_check.
    METHODS create_proj               FOR TESTING RAISING cx_static_check.
    METHODS create_proj_pos_case1     FOR TESTING RAISING cx_static_check.
    METHODS generate_data             FOR TESTING RAISING cx_static_check.
    METHODS createWithAIMockAIService FOR TESTING RAISING cx_static_check.
    METHODS printGuestList            FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_action_methods IMPLEMENTATION.
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

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 0 status = 'I' )
        ( uuid = 'DEC190889AC21FE08191A45962D04212' title = 'Event 2' max_visitors_number = 2 free_visitor_seats = 1 status = 'I' )
        ( uuid = 'DEC190889AC21FE08191A45962D04213' title = 'Event 3' max_visitors_number = 4 free_visitor_seats = 0 status = 'F' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA result      TYPE TABLE FOR ACTION RESULT zpra_mf_r_musicfestival\\MusicFestival~publish.
    DATA mapped      TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival.
    DATA failed      TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->publish( EXPORTING keys     = CORRESPONDING #( entity_keys )
                               CHANGING  result   = result
                                         mapped   = mapped
                                         failed   = failed
                                         reported = reported ).

    " expect input keys and output keys to be same and Status
    DATA exp LIKE result.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04211'  %param-Status = 'F' ) ).

    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act_fb LIKE result.

    act_fb = CORRESPONDING #( result MAPPING Uuid = Uuid
                                (  %param = %param MAPPING Status = Status
                                EXCEPT * )
                            EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act_fb ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT DATA(read_result).

    act_fb = VALUE #( FOR t IN read_result
                      ( Uuid          = t-Uuid
                        %param-Status = t-Status ) ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act_fb ).

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04212' ) ).

    " execute the action
    class_under_test->publish( EXPORTING keys     = CORRESPONDING #( entity_keys )
                               CHANGING  result   = result
                                         mapped   = mapped
                                         failed   = failed
                                         reported = reported ).

    " expect input keys and output keys to be same and Status
    DATA exp_publish LIKE result.
    exp_publish = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04212'  %param-Status = 'P' ) ).

    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act_publish LIKE result.

    act_publish = CORRESPONDING #( result MAPPING Uuid = Uuid
                                (  %param = %param MAPPING Status = Status
                                EXCEPT * )
                            EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp_publish
                                        act = act_publish ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT DATA(read_result_publish).

    act_publish = VALUE #( FOR t IN read_result_publish
                           ( Uuid          = t-Uuid
                             %param-Status = t-Status ) ).

    cl_abap_unit_assert=>assert_equals( exp = exp_publish
                                        act = act_publish ).
  ENDMETHOD.

  METHOD create_proj.
    TEST-INJECTION create_project.
      create_project_details = VALUE #( messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ) ).
          END-TEST-INJECTION.

    DATA mock_project TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mock_project = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 0 status = 'I' )
        ( uuid = 'DEC190889AC21FE08191A45962D04212' title = 'Event 2' max_visitors_number = 2 free_visitor_seats = 1 status = 'I' )
        ( uuid = 'DEC190889AC21FE08191A45962D04213' title = 'Event 3' max_visitors_number = 4 free_visitor_seats = 0 status = 'F' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mock_project ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA result      TYPE TABLE FOR ACTION RESULT zpra_mf_r_musicfestival\\MusicFestival~CrProj.
    DATA mapped      TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival.
    DATA failed      TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->createproject( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                     CHANGING  result   = result
                                               mapped   = mapped
                                               failed   = failed
                                               reported = reported ).

    cl_abap_unit_assert=>assert_not_initial( act = reported ).
  ENDMETHOD.

  METHOD create_proj_pos_case1.
    TEST-INJECTION create_project.
      project_details-project = 'EVENT1'.
    END-TEST-INJECTION.

    DATA mock_project TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mock_project = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 0 status = 'I' )
        ( uuid = 'DEC190889AC21FE08191A45962D04212' title = 'Event 2' max_visitors_number = 2 free_visitor_seats = 1 status = 'I' )
        ( uuid = 'DEC190889AC21FE08191A45962D04213' title = 'Event 3' max_visitors_number = 4 free_visitor_seats = 0 status = 'F' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mock_project ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA result      TYPE TABLE FOR ACTION RESULT zpra_mf_r_musicfestival\\MusicFestival~CrProj.
    DATA mapped      TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival.
    DATA failed      TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    CLEAR entity_keys.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04212' ) ).

    " execute the action
    class_under_test->createproject( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                     CHANGING  result   = result
                                               mapped   = mapped
                                               failed   = failed
                                               reported = reported ).

    cl_abap_unit_assert=>assert_initial( act = reported ).

    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( project_id ) WITH CORRESPONDING #( entity_keys )
         RESULT DATA(read_result).

    IF read_result IS INITIAL.
      RETURN.
    ENDIF.
    cl_abap_unit_assert=>assert_equals( exp = 'MF_EVENT1'
                                        act = read_result[ 1 ]-project_id ).
  ENDMETHOD.

  METHOD cancel.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 0 status = 'I' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA result      TYPE TABLE FOR ACTION RESULT zpra_mf_r_musicfestival\\MusicFestival~cancel.
    DATA mapped      TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival.
    DATA failed      TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA reported    TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->cancel( EXPORTING keys     = CORRESPONDING #( entity_keys )
                              CHANGING  result   = result
                                        mapped   = mapped
                                        failed   = failed
                                        reported = reported ).

    " expect input keys and output keys to be same and Status
    DATA exp LIKE result.
    exp = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04211'  %param-Status = 'C' ) ).

    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act LIKE result.

    act = CORRESPONDING #( result MAPPING Uuid = Uuid
                                (  %param = %param MAPPING Status = Status
                                EXCEPT * )
                            EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT DATA(read_result).

    act = VALUE #( FOR t IN read_result
                   ( Uuid          = t-Uuid
                     %param-Status = t-Status ) ).

    cl_abap_unit_assert=>assert_equals( exp = exp
                                        act = act ).
  ENDMETHOD.

  METHOD generate_data.
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA entity_keys                 TYPE STANDARD TABLE OF ty_entity_key.
    DATA generate_sample_data_action TYPE TABLE FOR ACTION IMPORT ZPRA_MF_R_MusicFestival~generateSampleData.

    generate_sample_data_action = VALUE #( ( %cid = 'Root1' ) ).
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    MODIFY ENTITY zpra_mf_r_musicfestival
           EXECUTE generatesampledata FROM generate_sample_data_action
           MAPPED   DATA(mapped_generate_sample_data)
           FAILED   DATA(failed_generate_sample_data)
           REPORTED DATA(reported_generate_sample_data).

    DATA(visitor_count) = lines( mapped_generate_sample_data-visits ).
    DATA(music_festival_count) = lines( mapped_generate_sample_data-musicfestival ).
    "
    cl_abap_unit_assert=>assert_equals( exp = 8
                                        act = visitor_count ).
    cl_abap_unit_assert=>assert_equals( exp = 5
                                        act = music_festival_count ).
  ENDMETHOD.

  METHOD createWithAIMockAIService.
    DATA lo_gen_ai_util_double TYPE REF TO zif_pra_mf_gen_ai_util.

    lo_gen_ai_util_double ?= cl_abap_testdouble=>create( 'zif_pra_mf_gen_ai_util' ).

    cl_abap_testdouble=>configure_call( lo_gen_ai_util_double )->returning(
        VALUE zif_pra_mf_gen_ai_util=>llm_response_structure(
                  title       = 'Tango Tales Buenos Aires'
                  description = 'Experience the passionate and intricate world of Argentine Tango.' )
                                                              )->ignore_all_parameters(
                                                              )->and_expect( )->is_called_once( ).

    lo_gen_ai_util_double->generate_music_festival_data( language        = 'EN'
                                                         tags            = 'rock, outdoor'
                                                         rhyme_indicator = abap_true ).

    class_under_test->ai_service = lo_gen_ai_util_double.

    DATA keys     TYPE TABLE FOR ACTION IMPORT zpra_mf_r_musicfestival\\musicfestival~createwithai.
    DATA mapped   TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival.
    DATA failed   TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA reported TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.

    keys = VALUE #( ( %cid   = '%SADL_FACTORY_ACTION_INDEX_CID__1'
                      %param = VALUE #( %is_draft = '01'
                                        language  = 'EN'
                                        tags      = 'rock, outdoor'
                                        rhyme     = 'X'
                                        %control  = VALUE #( language = '01'
                                                             tags     = '01'
                                                             rhyme    = '01' ) ) ) ).

    class_under_test->createwithai( EXPORTING keys     = keys
                                    CHANGING  mapped   = mapped
                                              failed   = failed
                                              reported = reported ).

    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( Title Description ) WITH CORRESPONDING #( mapped-musicfestival )
         RESULT DATA(music_festival_events).

    cl_abap_unit_assert=>assert_equals( exp = |Tango Tales Buenos Aires|
                                        act = music_festival_events[ 1 ]-title ).
    cl_abap_unit_assert=>assert_true(
        act = xsdbool( music_festival_events[ 1 ]-description CS |Experience the passionate and intricate world of Argentine Tango.| ) ).
  ENDMETHOD.

  METHOD printguestlist.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 2 status = 'I' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_music_festival_key,
             uuid TYPE sysuuid_x16,
           END OF ty_music_festival_key.

    DATA result              TYPE TABLE FOR ACTION RESULT zpra_mf_r_musicfestival\\MusicFestival~printGuestList.
    DATA mapped              TYPE RESPONSE FOR MAPPED EARLY zpra_mf_r_musicfestival.
    DATA failed              TYPE RESPONSE FOR FAILED EARLY zpra_mf_r_musicfestival.
    DATA reported            TYPE RESPONSE FOR REPORTED EARLY zpra_mf_r_musicfestival.
    DATA music_festival_keys TYPE STANDARD TABLE OF ty_music_festival_key.

    " specify test entity keys
    music_festival_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the action
    class_under_test->printguestlist( EXPORTING keys     = CORRESPONDING #( music_festival_keys )
                                      CHANGING  result   = result
                                                mapped   = mapped
                                                failed   = failed
                                                reported = reported ).

    cl_abap_unit_assert=>assert_not_initial( act = zbp_pra_mf_r_musicfestival=>bgmc_processes ).
    cl_abap_unit_assert=>assert_equals( exp = 'DEC190889AC21FE08191A45962D04211'
                                        act = result[ 1 ]-Uuid ).
  ENDMETHOD.
ENDCLASS.


" -------------------------------------------------------------
" Local class to test determinations in behavior implementations   -
" -------------------------------------------------------------
CLASS ltcl_determination_methods DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival. " the class to be tested
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.     " cds test double framework

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.

    METHODS determineStatus         FOR TESTING RAISING cx_static_check.
    METHODS determineAvailableSeats FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_determination_methods IMPLEMENTATION.
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

  METHOD determineStatus.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' title = 'Event 1' max_visitors_number = 2 free_visitor_seats = 2 )
        ( uuid = 'DEC190889AC21FE08191A45962D04212' title = 'Event 2' max_visitors_number = 2 free_visitor_seats = 0 status = 'P' )
        ( uuid = 'DEC190889AC21FE08191A45962D04213' title = 'Event 3' max_visitors_number = 4 free_visitor_seats = 2 status = 'F' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    " call the method to be tested
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported    TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA entity_keys TYPE STANDARD TABLE OF ty_entity_key.

    " specify test entity keys
    entity_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    " execute the determination
    class_under_test->determineStatus( EXPORTING keys     = CORRESPONDING #( entity_keys )
                                       CHANGING  reported = reported ).

    cl_abap_unit_assert=>assert_initial( act = reported ).

    " additionally check by reading entity state
    READ ENTITY zpra_mf_r_musicfestival
         FIELDS ( Uuid Status ) WITH CORRESPONDING #( entity_keys )
         RESULT DATA(music_festival_status).

    " expect input keys and output keys to be same and Status
    DATA exp_inprogress LIKE music_festival_status.
    exp_inprogress = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04211' Status = 'I' ) ).

    " current result; copy only fields of interest - i.e. Uuid and Status
    DATA act_inprogress LIKE music_festival_status.

    act_inprogress = CORRESPONDING #( music_festival_status MAPPING Uuid = Uuid
                                 Status = Status
                                EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( exp = exp_inprogress
                                        act = act_inprogress ).
  ENDMETHOD.

  METHOD determineAvailableSeats.
    TYPES: BEGIN OF ty_entity_key,
             uuid TYPE sysuuid_x16,
           END OF ty_entity_key.

    DATA reported        TYPE RESPONSE FOR REPORTED zpra_mf_r_musicfestival.
    DATA failed          TYPE RESPONSE FOR FAILED zpra_mf_r_musicfestival.
    DATA mapped          TYPE RESPONSE FOR MAPPED zpra_mf_r_musicfestival.
    DATA music_festivals TYPE TABLE FOR READ RESULT zpra_mf_r_musicfestival.
    DATA entity_keys     TYPE STANDARD TABLE OF ty_entity_key.

    MODIFY ENTITIES OF zpra_mf_r_musicfestival
           ENTITY MusicFestival
           CREATE SET FIELDS WITH
           VALUE #( ( %cid              = 'ROOT1'
                      MaxVisitorsNumber = 2
                      FreeVisitorSeats  = 0 ) )
           CREATE BY \_Visits SET FIELDS WITH
           VALUE #( ( %cid_ref = 'ROOT1'
                      %target  = VALUE #( ( %cid        = 'VISITS1'
                                            VisitorUuid = 'DEC190889AC21FE08191A45962D04210' ) ) ) )
           ENTITY Visits
           EXECUTE book
           FROM VALUE #( ( %cid_ref          = 'VISITS1' ) )

           MAPPED mapped
           FAILED failed
           REPORTED reported.

    LOOP AT mapped-musicfestival ASSIGNING FIELD-SYMBOL(<music_festival_mapped>).
      entity_keys = VALUE #( (  uuid =  <music_festival_mapped>-uuid ) ).

      READ ENTITIES OF zpra_mf_r_musicfestival IN LOCAL MODE
           ENTITY MusicFestival
           FIELDS ( FreeVisitorSeats )
           WITH CORRESPONDING #( entity_keys )
           RESULT music_festivals.
    ENDLOOP.
    ASSIGN music_festivals[ 1 ] TO FIELD-SYMBOL(<music_festival>).
    cl_abap_unit_assert=>assert_equals( exp = 1
                                        act = <music_festival>-FreeVisitorSeats ).
  ENDMETHOD.
ENDCLASS.


" -------------------------------------------------------------
" Local class to test authorizations in behavior implementations         -
" -------------------------------------------------------------
CLASS ltc_authorization_methods DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO lhc_zpra_mf_r_musicfestival. " the class to be tested
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.     " cds test double framework
    CLASS-DATA sql_test_environment TYPE REF TO if_osql_test_environment.    " abap sql test double framework

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " roll back any changes
    METHODS teardown.
    METHODS get_global_authorizations   FOR TESTING.
    METHODS get_instance_authorizations FOR TESTING.

    TYPES reported_early TYPE RESPONSE FOR REPORTED EARLY ZPRA_MF_R_MusicFestival.
    TYPES failed_early   TYPE RESPONSE FOR FAILED EARLY ZPRA_MF_R_MusicFestival.

    DATA ms_reported_early TYPE reported_early.
    DATA ms_failed_early   TYPE failed_early.
ENDCLASS.


CLASS ltc_authorization_methods IMPLEMENTATION.
  METHOD class_setup.
    " Create the class under Test
    " The class is abstract but can be constructed with the FOR TESTING
    CREATE OBJECT class_under_test FOR TESTING.
    " Create test doubles for database dependencies
    " The EML READ operation will then also access the test doubles
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                               i_for_entities = VALUE #( i_select_base_dependencies = abap_true
                                                         ( i_for_entity      = 'ZPRA_MF_R_MUSICFESTIVAL'
                                                           i_dependency_list = VALUE #( ( 'ZPRA_MF_A_MF' ) ) )
                                                         ( i_for_entity      = 'ZPRA_MF_R_VISITOR'
                                                           i_dependency_list = VALUE #( ( 'ZPRA_MF_A_VSTR' ) ) )
                                                         ( i_for_entity      = 'ZPRA_MF_R_VISIT'
                                                           i_dependency_list = VALUE #( ( 'ZPRA_MF_A_VST' ) ) ) ) ).
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

  METHOD get_global_authorizations.
    DATA requested_authorizations TYPE STRUCTURE FOR GLOBAL AUTHORIZATION REQUEST ZPRA_MF_R_MusicFestival\\MusicFestival.
    DATA result                   TYPE STRUCTURE FOR GLOBAL AUTHORIZATION RESULT ZPRA_MF_R_MusicFestival\\MusicFestival.

    requested_authorizations-%delete = if_abap_behv=>mk-on.

    class_under_test->get_global_authorizations( EXPORTING requested_authorizations = requested_authorizations
                                                 CHANGING  result                   = result
                                                           reported                 = ms_reported_early ).
    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>auth-allowed
                                        act = result-%delete ).

    requested_authorizations-%create = if_abap_behv=>mk-on.

    class_under_test->get_global_authorizations( EXPORTING requested_authorizations = requested_authorizations
                                                 CHANGING  result                   = result
                                                           reported                 = ms_reported_early ).
    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>auth-allowed
                                        act = result-%create ).

    requested_authorizations-%update = if_abap_behv=>mk-on.

    class_under_test->get_global_authorizations( EXPORTING requested_authorizations = requested_authorizations
                                                 CHANGING  result                   = result
                                                           reported                 = ms_reported_early ).
    cl_abap_unit_assert=>assert_equals( exp = if_abap_behv=>auth-allowed
                                        act = result-%update ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
    DATA entity_keys              TYPE TABLE FOR AUTHORIZATION KEY ZPRA_MF_R_MusicFestival\\MusicFestival.
    DATA requested_authorizations TYPE STRUCTURE FOR AUTHORIZATION REQUEST ZPRA_MF_R_MusicFestival\\MusicFestival.
    DATA result                   TYPE TABLE FOR AUTHORIZATION RESULT ZPRA_MF_R_MusicFestival\\MusicFestival.
    " Define mock visitor data with a known UUID
    DATA mf_data                  TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA visitor_data             TYPE STANDARD TABLE OF zpra_mf_a_vstr.

    DATA(mock_uuid) = '5E832E34B1891FE0A8D34000F0477ECB'.
    APPEND VALUE #( uuid = mock_uuid ) TO mf_data.
    cds_test_environment->insert_test_data( i_data = mf_data ).

    entity_keys = VALUE #( (  uuid = mock_uuid ) ).

    mock_uuid = '3A959FF37AC81FE0A3DF859190FA47DB'.
    APPEND VALUE #( uuid = mock_uuid ) TO visitor_data.
    cds_test_environment->insert_test_data( i_data = visitor_data ).

    requested_authorizations-%update = if_abap_behv=>mk-on.

    class_under_test->get_instance_authorizations( EXPORTING keys                     = entity_keys
                                                             requested_authorizations = requested_authorizations
                                                   CHANGING  result                   = result
                                                             failed                   = ms_failed_early
                                                             reported                 = ms_reported_early ).
    cl_abap_unit_assert=>assert_initial( result ).

    requested_authorizations-%update = if_abap_behv=>mk-off.
    class_under_test->get_instance_authorizations( EXPORTING keys                     = entity_keys
                                                             requested_authorizations = requested_authorizations
                                                   CHANGING  result                   = result
                                                             failed                   = ms_failed_early
                                                             reported                 = ms_reported_early ).
    cl_abap_unit_assert=>assert_initial( result ).
  ENDMETHOD.
ENDCLASS.


CLASS ltc_saver_methods DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO lsc_zpra_mf_r_musicfestival. " the class to be tested
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.     " cds test double framework

    DATA event_test_environment TYPE REF TO if_rap_event_test_environment.

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.

    METHODS create_mf_event_trigger       FOR TESTING RAISING cx_static_check.
    METHODS update_mf_event_trigger       FOR TESTING RAISING cx_static_check.
    METHODS delete_mf_event_trigger       FOR TESTING RAISING cx_static_check.
    METHODS visit_booked_event_trigger    FOR TESTING RAISING cx_static_check.
    METHODS visit_cancelled_event_trigger FOR TESTING RAISING cx_static_check.
    METHODS artist_create_event_trigger   FOR TESTING RAISING cx_static_check.
    METHODS artist_delete_event_trigger   FOR TESTING RAISING cx_static_check.
    METHODS ent_proj_assign_event_trigger FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_saver_methods IMPLEMENTATION.
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
    event_test_environment->clear( ).
    event_test_environment->destroy( ).
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD create_mf_event_trigger.
    DATA reported TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA create   TYPE REQUEST FOR CHANGE zpra_mf_r_musicfestival.

    event_test_environment = cl_rap_event_test_environment=>create(
                                 VALUE #( ( entity_name = 'ZPRA_MF_R_MUSICFESTIVAL' event_name = 'MUSICEVENTCREATED' ) ) ).
    create-musicfestival = VALUE #( ( Uuid          = 'DEC190889AC21FE08191A45962D04217'
                                      Title         = 'Test Event Create'
                                      EventDateTime = '2028-01-01T00:00:00.0000000'
                                      Status        = 'I' ) ).
    class_under_test->save_modified( EXPORTING create   = create
                                               update   = VALUE #( )
                                               delete   = VALUE #( )
                                     CHANGING  reported = reported ).

    DATA create_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventCreated.
    create_event_payload_act = event_test_environment->get_event(
                                   entity_name = 'ZPRA_MF_R_MUSICFESTIVAL'
                                   event_name  = 'MUSICEVENTCREATED' )->get_payload( )->*.

    DATA create_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventCreated.
    create_event_payload_exp = VALUE #( ( Uuid          = 'DEC190889AC21FE08191A45962D04217'
                                          Title         = 'Test Event Create'
                                          EventDateTime = '2028-01-01T00:00:00.0000000'
                                          Status        = 'I' ) ).

    cl_abap_unit_assert=>assert_equals( exp = create_event_payload_exp
                                        act = create_event_payload_act ).
  ENDMETHOD.

  METHOD update_mf_event_trigger.
    DATA update         TYPE REQUEST FOR CHANGE zpra_mf_r_musicfestival.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.
    DATA reported       TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).
    vst_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' parent_uuid = 'DEC190889AC21FE08191A45962D04217' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' ) ).
    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'Artist1' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    event_test_environment = cl_rap_event_test_environment=>create(
                                 VALUE #( ( entity_name = 'ZPRA_MF_R_MUSICFESTIVAL' event_name = 'MUSICEVENTUPDATED' ) ) ).

    update-musicfestival = VALUE #( ( Uuid                         = 'DEC190889AC21FE08191A45962D04217'
                                      Title                        = 'Event 2'
                                      Status                       = 'P'
                                      MaxVisitorsNumber            = 3
                                      FreeVisitorSeats             = 3
                                      VisitorsFeeAmount            = 10
                                      VisitorsFeeCurrency          = 'EUR'
                                      EventDateTime                = '2028-01-03T00:00:00.0000000'
                                      %control-Title               = if_abap_behv=>mk-on
                                      %control-Status              = if_abap_behv=>mk-on
                                      %control-MaxVisitorsNumber   = if_abap_behv=>mk-on
                                      %control-FreeVisitorSeats    = if_abap_behv=>mk-on
                                      %control-VisitorsFeeAmount   = if_abap_behv=>mk-on
                                      %control-VisitorsFeeCurrency = if_abap_behv=>mk-on
                                      %control-EventDateTime       = if_abap_behv=>mk-on ) ).

    class_under_test->save_modified( EXPORTING create   = VALUE #( )
                                               update   = update
                                               delete   = VALUE #( )
                                     CHANGING  reported = reported ).

    DATA update_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventUpdated.
    update_event_payload_act = event_test_environment->get_event(
                                   entity_name = 'ZPRA_MF_R_MUSICFESTIVAL'
                                   event_name  = 'MUSICEVENTUPDATED' )->get_payload( )->*.

    DATA update_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventUpdated.
    update_event_payload_exp = VALUE #( ( Uuid                       = 'DEC190889AC21FE08191A45962D04217'
                                          Title                      = 'Event 2'
                                          Status                     = 'P'
                                          MaxVisitorsNumber          = 3
                                          FreeVisitorSeats           = 3
                                          VisitorsFeeAmount          = 10
                                          VisitorsFeeCurrency        = 'EUR'
                                          EventDateTime              = '2028-01-03T00:00:00.0000000'
                                          __before-Title             = 'Event 1'
                                          __before-MaxVisitorsNumber = 2
                                          __before-EventDateTime     = '2028-01-01T00:00:00.0000000' ) ).

    cl_abap_unit_assert=>assert_equals( exp = update_event_payload_exp
                                        act = update_event_payload_act ).
  ENDMETHOD.

  METHOD delete_mf_event_trigger.
    DATA delete       TYPE REQUEST FOR DELETE zpra_mf_r_musicfestival.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA reported     TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    event_test_environment = cl_rap_event_test_environment=>create(
                                 VALUE #( ( entity_name = 'ZPRA_MF_R_MUSICFESTIVAL' event_name = 'MUSICEVENTDELETED' ) ) ).

    delete-musicfestival = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    class_under_test->save_modified( EXPORTING create   = VALUE #( )
                                               update   = VALUE #( )
                                               delete   = delete
                                     CHANGING  reported = reported ).

    DATA delete_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventDeleted.
    delete_event_payload_act = event_test_environment->get_event(
                                   entity_name = 'ZPRA_MF_R_MUSICFESTIVAL'
                                   event_name  = 'MUSICEVENTDELETED' )->get_payload( )->*.

    DATA delete_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventDeleted.
    delete_event_payload_exp = VALUE #( ( Uuid  = 'DEC190889AC21FE08191A45962D04217'
                                          Title = 'Event 1' ) ).

    cl_abap_unit_assert=>assert_equals( exp = delete_event_payload_exp
                                        act = delete_event_payload_act ).
  ENDMETHOD.

  METHOD visit_booked_event_trigger.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.
    DATA update         TYPE REQUEST FOR CHANGE zpra_mf_r_musicfestival.
    DATA reported       TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.

    TEST-INJECTION read_artists.
      visitor_names = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04210' Name = 'visitor1' ) ).
    END-TEST-INJECTION.
    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'visitor1' ) ).
    mf_mock_data = VALUE #( ( uuid                = 'DEC190889AC21FE08191A45962D04217'
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = 2
                              free_visitor_seats  = 1 ) ).
    vst_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04211' parent_uuid = 'DEC190889AC21FE08191A45962D04217' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    event_test_environment = cl_rap_event_test_environment=>create(
                                 VALUE #( ( entity_name = 'ZPRA_MF_R_VISIT' event_name = 'VISITBOOKED' ) ) ).

    update-visits = VALUE #( ( Uuid            = 'DEC190889AC21FE08191A45962D04211'
                               ParentUuid      = 'DEC190889AC21FE08191A45962D04217'
                               VisitorUuid     = 'DEC190889AC21FE08191A45962D04210'
                               Status          = zcl_pra_mf_enum_visit_status=>booked
                               %control-Status = if_abap_behv=>mk-on ) ).

    class_under_test->save_modified( EXPORTING create   = VALUE #( )
                                               update   = update
                                               delete   = VALUE #( )
                                     CHANGING  reported = reported ).

    DATA visit_booked_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_visit~VisitBooked.
    visit_booked_event_payload_act = event_test_environment->get_event(
                                         entity_name = 'ZPRA_MF_R_VISIT'
                                         event_name  = 'VISITBOOKED' )->get_payload( )->*.

    DATA visit_booked_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_visit~VisitBooked.
    visit_booked_event_payload_exp = VALUE #( ( Uuid        = 'DEC190889AC21FE08191A45962D04211'
                                                ParentUuid  = 'DEC190889AC21FE08191A45962D04217'
                                                VisitorUuid = 'DEC190889AC21FE08191A45962D04210'
                                                name        = 'visitor1' ) ).

    cl_abap_unit_assert=>assert_equals( exp = visit_booked_event_payload_exp
                                        act = visit_booked_event_payload_act ).
  ENDMETHOD.

  METHOD visit_cancelled_event_trigger.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.
    DATA update         TYPE REQUEST FOR CHANGE zpra_mf_r_musicfestival.
    DATA reported       TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.

    TEST-INJECTION read_artists.
      visitor_names = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04210' Name = 'visitor1' ) ).
    END-TEST-INJECTION.

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

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    event_test_environment = cl_rap_event_test_environment=>create(
                                 VALUE #( ( entity_name = 'ZPRA_MF_R_VISIT' event_name = 'VISITCANCELLED' ) ) ).

    update-visits = VALUE #( ( Uuid            = 'DEC190889AC21FE08191A45962D04211'
                               ParentUuid      = 'DEC190889AC21FE08191A45962D04217'
                               VisitorUuid     = 'DEC190889AC21FE08191A45962D04210'
                               Status          = zcl_pra_mf_enum_visit_status=>cancelled
                               %control-Status = if_abap_behv=>mk-on ) ).

    class_under_test->save_modified( EXPORTING create   = VALUE #( )
                                               update   = update
                                               delete   = VALUE #( )
                                     CHANGING  reported = reported ).

    DATA visit_cancel_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_visit~VisitCancelled.
    visit_cancel_event_payload_act = event_test_environment->get_event(
                                         entity_name = 'ZPRA_MF_R_VISIT'
                                         event_name  = 'VISITCANCELLED' )->get_payload( )->*.

    DATA visit_cancel_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_visit~VisitCancelled.
    visit_cancel_event_payload_exp = VALUE #( ( Uuid        = 'DEC190889AC21FE08191A45962D04211'
                                                ParentUuid  = 'DEC190889AC21FE08191A45962D04217'
                                                VisitorUuid = 'DEC190889AC21FE08191A45962D04210'
                                                name        = 'visitor1' ) ).

    cl_abap_unit_assert=>assert_equals( exp = visit_cancel_event_payload_exp
                                        act = visit_cancel_event_payload_act ).
  ENDMETHOD.

  METHOD artist_create_event_trigger.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA update         TYPE REQUEST FOR CHANGE zpra_mf_r_musicfestival.
    DATA reported       TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.

    TEST-INJECTION artist_updated.
      music_event_updated-ArtistName = 'Visitor1'.
      music_event_updated-__before-ArtistName = 'Artist1'.
    END-TEST-INJECTION.

    TEST-INJECTION read_artists.
      visitor_names = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04210' Name = 'Artist1' )
                               ( uuid = 'DEC190889AC21FE08191A45962D04212' name = 'Visitor1' ) ).
    END-TEST-INJECTION.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'Artist1' )
                              ( uuid = 'DEC190889AC21FE08191A45962D04212' name = 'Visitor1' ) ).

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).

    vst_mock_data = VALUE #(
        parent_uuid = 'DEC190889AC21FE08191A45962D04217'
        ( uuid = 'DEC190889AC21FE08191A45962D04211' visitor_uuid = 'DEC190889AC21FE08191A45962D04210' artist_indicator = abap_true )
        ( uuid = 'DEC190889AC21FE08191A45962D04213' visitor_uuid = 'DEC190889AC21FE08191A45962D04212' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    event_test_environment = cl_rap_event_test_environment=>create(
                                 VALUE #( ( entity_name = 'ZPRA_MF_R_MUSICFESTIVAL' event_name = 'MUSICEVENTUPDATED' ) ) ).

    update-musicfestival = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04217' ) ).
    update-visits        = VALUE #( ( Uuid                     = 'DEC190889AC21FE08191A45962D04213'
                                      ArtistIndicator          = abap_true
                                      %control-ArtistIndicator = if_abap_behv=>mk-on ) ).

    class_under_test->save_modified( EXPORTING create   = VALUE #( )
                                               update   = update
                                               delete   = VALUE #( )
                                     CHANGING  reported = reported ).

    DATA update_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventUpdated.
    update_event_payload_act = event_test_environment->get_event(
                                   entity_name = 'ZPRA_MF_R_MUSICFESTIVAL'
                                   event_name  = 'MUSICEVENTUPDATED' )->get_payload( )->*.

    DATA update_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventUpdated.
    update_event_payload_exp = VALUE #( ( Uuid                       = 'DEC190889AC21FE08191A45962D04217'
                                          Title                      = 'Event 1'
                                          MaxVisitorsNumber          = 2
                                          EventDateTime              = '2028-01-01T00:00:00.0000000'
                                          ArtistName                 = 'Visitor1'
                                          __before-Title             = 'Event 1'
                                          __before-MaxVisitorsNumber = 2
                                          __before-EventDateTime     = '2028-01-01T00:00:00.0000000'
                                          __before-ArtistName        = 'Artist1' ) ).

    cl_abap_unit_assert=>assert_equals( exp = update_event_payload_exp
                                        act = update_event_payload_act ).
  ENDMETHOD.

  METHOD artist_delete_event_trigger.
    DATA mf_mock_data   TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA vst_mock_data  TYPE STANDARD TABLE OF zpra_mf_a_vst.
    DATA vstr_mock_data TYPE STANDARD TABLE OF zpra_mf_a_vstr.
    DATA reported       TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA update         TYPE REQUEST FOR CHANGE zpra_mf_r_musicfestival.
    DATA delete         TYPE REQUEST FOR DELETE zpra_mf_r_musicfestival.

    vstr_mock_data = VALUE #( ( uuid = 'DEC190889AC21FE08191A45962D04210' name = 'Artist1' ) ).
    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).
    vst_mock_data = VALUE #( ( uuid             = 'DEC190889AC21FE08191A45962D04211'
                               parent_uuid      = 'DEC190889AC21FE08191A45962D04217'
                               visitor_uuid     = 'DEC190889AC21FE08191A45962D04210'
                               artist_indicator = abap_true ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).
    cds_test_environment->insert_test_data( i_data = vst_mock_data ).
    cds_test_environment->insert_test_data( i_data = vstr_mock_data ).

    event_test_environment = cl_rap_event_test_environment=>create(
                                 VALUE #( ( entity_name = 'ZPRA_MF_R_MUSICFESTIVAL' event_name = 'MUSICEVENTUPDATED' ) ) ).

    update-musicfestival = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04217' ) ).
    delete-visits = VALUE #( ( Uuid = 'DEC190889AC21FE08191A45962D04211' ) ).

    class_under_test->save_modified( EXPORTING create   = VALUE #( )
                                               update   = update
                                               delete   = delete
                                     CHANGING  reported = reported ).

    DATA update_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventUpdated.
    update_event_payload_act = event_test_environment->get_event(
                                   entity_name = 'ZPRA_MF_R_MUSICFESTIVAL'
                                   event_name  = 'MUSICEVENTUPDATED' )->get_payload( )->*.

    DATA update_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~MusicEventUpdated.
    update_event_payload_exp = VALUE #( ( Uuid                       = 'DEC190889AC21FE08191A45962D04217'
                                          Title                      = 'Event 1'
                                          MaxVisitorsNumber          = 2
                                          EventDateTime              = '2028-01-01T00:00:00.0000000'
                                          __before-Title             = 'Event 1'
                                          __before-MaxVisitorsNumber = 2
                                          __before-EventDateTime     = '2028-01-01T00:00:00.0000000'
                                          __before-ArtistName        = 'Artist1' ) ).

    cl_abap_unit_assert=>assert_equals( exp = update_event_payload_exp
                                        act = update_event_payload_act ).
  ENDMETHOD.

  METHOD ent_proj_assign_event_trigger.
    DATA mf_mock_data TYPE STANDARD TABLE OF zpra_mf_a_mf.
    DATA reported     TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.
    DATA update       TYPE REQUEST FOR CHANGE zpra_mf_r_musicfestival.

    mf_mock_data = VALUE #(
        ( uuid = 'DEC190889AC21FE08191A45962D04217' event_date_time = '2028-01-01T00:00:00.0000000' title = 'Event 1' max_visitors_number = 2 ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( i_data = mf_mock_data ).

    event_test_environment = cl_rap_event_test_environment=>create(
        VALUE #( ( entity_name = 'ZPRA_MF_R_MUSICFESTIVAL' event_name = 'EntProjectAssigned' ) ) ).
    update-musicfestival = VALUE #( ( Uuid                = 'DEC190889AC21FE08191A45962D04217'
                                      Title               = 'Event 1'
                                      EventDateTime       = '2028-01-01T00:00:00.0000000'
                                      project_id          = 'proj1'
                                      %control-project_id = if_abap_behv=>mk-on ) ).
    class_under_test->save_modified( EXPORTING create   = VALUE #( )
                                               update   = update
                                               delete   = VALUE #( )
                                     CHANGING  reported = reported ).

    DATA proj_assign_event_payload_act TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~EntProjectAssigned.
    proj_assign_event_payload_act = event_test_environment->get_event(
                                        entity_name = 'ZPRA_MF_R_MUSICFESTIVAL'
                                        event_name  = 'EntProjectAssigned' )->get_payload( )->*.

    DATA proj_assign_event_payload_exp TYPE TABLE FOR EVENT zpra_mf_r_musicfestival~EntProjectAssigned.
    proj_assign_event_payload_exp = VALUE #( ( Uuid          = 'DEC190889AC21FE08191A45962D04217'
                                               Title         = 'Event 1'
                                               EventDateTime = '2028-01-01T00:00:00.0000000'
                                               Project_Id    = 'proj1' ) ).

    cl_abap_unit_assert=>assert_equals( exp = proj_assign_event_payload_exp
                                        act = proj_assign_event_payload_act ).
  ENDMETHOD.
ENDCLASS.
