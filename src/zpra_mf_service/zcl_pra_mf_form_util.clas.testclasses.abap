CLASS ltcl_fp_fdp_glo_itf DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_fp_fdp_api.
ENDCLASS.


CLASS ltcl_fp_fdp_glo_itf IMPLEMENTATION.
  METHOD if_fp_fdp_api~get_keys.
    rt_keys = VALUE if_fp_fdp_api=>tt_select_keys(
                        ( name = 'UUID' value = 'DEC190889AC21FE08191A45962D04217' data_type = 'CHAR' ) ).
  ENDMETHOD.

  METHOD if_fp_fdp_api~read_to_xml_v2.
    " call the method to be tested
    TYPES: BEGIN OF ty_music_festival_key,
             uuid TYPE sysuuid_x16,
           END OF ty_music_festival_key.

    DATA music_festival_keys TYPE STANDARD TABLE OF ty_music_festival_key.
    DATA xml_string          TYPE string.
    DATA xml_xstring         TYPE xstring.

    " specify test entity keys
    music_festival_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    READ ENTITY zpra_mf_r_musicfestival
         ALL FIELDS WITH CORRESPONDING #( music_festival_keys )
         RESULT DATA(music_festivals).

    READ TABLE music_festivals INTO DATA(music_festival) INDEX 1.

    " Assign the XML content to the string variable
    xml_string = |<?xml version="1.0" encoding="UTF-8"?>| &
                    |<Form version="2">| &
                    | <MusicFestival>| &
                    |   <Uuid>{ music_festival-Uuid }</Uuid>| &
                    |   <Title>{ music_festival-Title }</Title>| &
                    |   <Description>{ music_festival-Description }</Description>| &
                    |   <EventDateTime>{ music_festival-EventDateTime }</EventDateTime>| &
                    |   <MaxVisitorsNumber>{ music_festival-MaxVisitorsNumber }</MaxVisitorsNumber>| &
                    |   <BookedSeats>{ music_festival-MaxVisitorsNumber - music_festival-FreeVisitorSeats }</BookedSeats>| &
                    |   <FreeVisitorSeats>{ music_festival-FreeVisitorSeats }</FreeVisitorSeats>| &
                    |   <VisitorsFeeAmount>{ music_festival-VisitorsFeeAmount }</VisitorsFeeAmount>| &
                    |   <VisitorsFeeCurrency>{ music_festival-VisitorsFeeCurrency }</VisitorsFeeCurrency>| &
                    |   <Status>I</Status>| &
                    |   <StatusText>In-Preparation</StatusText>| &
                    |   <StatusCriticality>0</StatusCriticality>| &
                    |   <CreatedBy/>| &
                    |   <CreatedAt/>| &
                    |   <LastChangedAt/>| &
                    |   <LastChangedBy/>| &
                    |   <LocalLastChangedAt/>| &
                    |   <project_id/>| &
                    |   <mimeType>application/pdf</mimeType>| &
                    |   <hyperlinkText>Music Event.pdf</hyperlinkText>| &
                    |   <OutputPdfData/>| &
                    |   <HasDraftEntity>false</HasDraftEntity>| &
                    |   <DraftAdministrativeDataUUID>00000000000000000000000000000000</DraftAdministrativeDataUUID>| &
                    |   <DraftEntityCreationDateTime>0000-00-00T00:00:00</DraftEntityCreationDateTime>| &
                    |   <DraftEntityLastChangeDateTime>0000-00-00T00:00:00</DraftEntityLastChangeDateTime>| &
                    |   <HasActiveEntity>false</HasActiveEntity>| &
                    |   <IsActiveEntity>true</IsActiveEntity>| &
                    |   <DraftEntityOperationCode/>| &
                    |   <_proj/>| &
                    |   <_Visits/>| &
                    | </MusicFestival>| &
                    |</Form>|.

    CALL TRANSFORMATION id
         SOURCE XML xml_string
         RESULT XML xml_xstring.

    rv_xml = xml_xstring.
  ENDMETHOD.

  METHOD if_fp_fdp_api~get_xsd.
  ENDMETHOD.

  METHOD if_fp_fdp_api~read_to_data.
  ENDMETHOD.

  METHOD if_fp_fdp_api~read_to_xml.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_pra_mf_util_form DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA cut                  TYPE REF TO zcl_pra_mf_form_util.    " the class to be tested
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment. " cds test double framework

    CONSTANTS application_service_def TYPE if_fp_fdp_api=>ty_service_definition VALUE 'ZPRA_MF_MUSICFESTIVAL'.
    CONSTANTS form_template           TYPE fpname                               VALUE 'ZPRA_MF_PDF_FORM_MF'.
    CONSTANTS pq_name                 TYPE cl_fp_ads_util=>ty_pq_name           VALUE 'DEFAULT'.
    CONSTANTS uuid                    TYPE sysuuid_x16                          VALUE 'DEC190889AC21FE08191A45962D04217'.
    CONSTANTS min_pdf_size            TYPE i                                    VALUE 190000.
    CONSTANTS max_pdf_size            TYPE i                                    VALUE 200000.
    CONSTANTS min_pdl_size            TYPE i                                    VALUE 100000.
    CONSTANTS max_pdl_size            TYPE i                                    VALUE 110000.

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.
    METHODS should_get_fp_fdp_api_instance FOR TESTING.
    METHODS should_render_form_for_preview FOR TESTING.
    METHODS should_render_form_for_pq      FOR TESTING.
    METHODS reject_invalid_form_name       FOR TESTING.
    METHODS reject_invalid_srv_defenition  FOR TESTING.

ENDCLASS.

CLASS zcl_pra_mf_form_util DEFINITION LOCAL FRIENDS ltcl_pra_mf_util_form.

CLASS ltcl_pra_mf_util_form IMPLEMENTATION.
  METHOD class_setup.
    " The EML READ operation will then also access the test doubles
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                               i_for_entities = VALUE #( ( i_for_entity = 'ZPRA_MF_R_MUSICFESTIVAL' )
                                                         ( i_for_entity = 'ZPRA_MF_R_VISITOR' )
                                                         ( i_for_entity = 'ZPRA_MF_R_VISIT' ) ) ).
    cds_test_environment->enable_double_redirection( ).
    TRY.
        cut = NEW #( ).
      CATCH cx_fp_fdp_error INTO DATA(error). " TODO: variable is assigned but never used (ABAP cleaner)
        " Fail the test if exception occurs
        cl_abap_unit_assert=>fail( ).
    ENDTRY.
  ENDMETHOD.

  METHOD class_teardown.
    " stop mocking
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    " clear the content of the test double per test
    cds_test_environment->clear_doubles( ).
    zcl_pra_mf_form_util=>skip = abap_false.
  ENDMETHOD.

  METHOD teardown.
    " Clean up any involved entity
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD should_render_form_for_preview.
    DATA music_festival_key TYPE sysuuid_x16.
    DATA mf_mock_data       TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #( ( uuid                = uuid
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = '10' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( mf_mock_data ).

    " specify test entity keys
    music_festival_key = uuid.

    " execute the method
    TRY.
        DATA(fp_fdp_service) = NEW ltcl_fp_fdp_glo_itf( ).

        DATA(pdf) = cut->render_form_for_preview( id             = music_festival_key
                                                  form_template  = form_template
                                                  fp_fdp_service = fp_fdp_service ).

        DATA(pdf_size_in_bytes) = strlen( pdf ).

        cl_abap_unit_assert=>assert_not_initial( pdf ).
        cl_abap_unit_assert=>assert_number_between(
            lower  = min_pdf_size
            upper  = max_pdf_size
            number = pdf_size_in_bytes
            msg    = |PDF size ({ pdf_size_in_bytes } bytes) is not within expected range ({ min_pdf_size }-{ max_pdf_size } bytes).| ).

      CATCH cx_fp_fdp_error
            cx_fp_form_reader
            cx_fp_ads_util INTO DATA(error). " TODO: variable is assigned but never used (ABAP cleaner)
        cl_abap_unit_assert=>fail( ). " Fail the test if exception occurs
    ENDTRY.
  ENDMETHOD.

  METHOD should_render_form_for_pq.
    DATA music_festival_key TYPE sysuuid_x16.
    DATA mf_mock_data       TYPE STANDARD TABLE OF zpra_mf_a_mf.

    mf_mock_data = VALUE #( ( uuid                = uuid
                              event_date_time     = '2028-01-01T00:00:00.0000000'
                              title               = 'Event 1'
                              max_visitors_number = '10' ) ).

    " insert test data into the cds test doubles
    cds_test_environment->insert_test_data( mf_mock_data ).

    " specify test entity keys
    music_festival_key = uuid.

    " execute the method
    TRY.
        DATA(fp_fdp_service) = NEW ltcl_fp_fdp_glo_itf( ).

        DATA(event_pdl) = cut->render_form_for_print_queue( id             = music_festival_key
                                                            pq_name        = pq_name
                                                            form_template  = form_template
                                                            fp_fdp_service = fp_fdp_service ).

        DATA(event_pdl_size_in_bytes) = xstrlen( event_pdl ).

        cl_abap_unit_assert=>assert_not_initial( event_pdl ).
        cl_abap_unit_assert=>assert_number_between(
            lower  = min_pdl_size
            upper  = max_pdl_size
            number = event_pdl_size_in_bytes
            msg    = |PDL size ({ event_pdl_size_in_bytes } bytes) is not within expected range ({ min_pdl_size }-{ max_pdl_size } bytes).| ).

      CATCH cx_fp_fdp_error
            cx_fp_form_reader
            cx_fp_ads_util INTO DATA(error). " TODO: variable is assigned but never used (ABAP cleaner)
        cl_abap_unit_assert=>fail( ). " Fail the test if exception occurs
    ENDTRY.
  ENDMETHOD.

  METHOD reject_invalid_form_name.
    TRY.
        DATA(fp_fdp_service) = NEW ltcl_fp_fdp_glo_itf( ).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(pdf) = cut->render_form_for_preview( id             = uuid
                                                  form_template  = 'INVALID_FORM'
                                                  fp_fdp_service = fp_fdp_service ).

        " Fail the test if no exception occurs
        cl_abap_unit_assert=>fail( ).

      CATCH cx_fp_form_reader.
        " expected exception was caugth => do nothing

      CATCH cx_root INTO DATA(unexpected_exception).
        " Any other exception should fail the test
        cl_abap_unit_assert=>fail(
            msg = |Expected exception cx_fp_form_reader did not occur. Unexpected exception of type { cl_abap_typedescr=>describe_by_data(
                                                                                                          unexpected_exception )->get_relative_name( ) } occurred: { unexpected_exception->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD reject_invalid_srv_defenition.
    TRY.
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(fp_fdp_service) = cut->get_fp_fdp_service( 'INVALID_SERVICE_DEFINITION' ).

        " Fail the test if no exception occurs
        cl_abap_unit_assert=>fail( ).

      CATCH cx_fp_fdp_error.
        " expected exception was caugth => do nothing

      CATCH cx_root INTO DATA(unexpected_exception).
        " Any other exception should fail the test
        cl_abap_unit_assert=>fail(
            msg = |Expected exception cx_fp_fdp_error did not occur. Unexpected exception of type { cl_abap_typedescr=>describe_by_data(
                                                                                                        unexpected_exception )->get_relative_name( ) } occurred: { unexpected_exception->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD should_get_fp_fdp_api_instance.
    TRY.

        DATA(fp_fdp_service) = cut->get_fp_fdp_service( application_service_def ).

        cl_abap_unit_assert=>assert_true( act = xsdbool( fp_fdp_service IS INSTANCE OF if_fp_fdp_api )
                                          msg = |Expected implementation of IF_FP_FDP_SERVICE did not found.| ).

      CATCH cx_fp_fdp_error
            cx_fp_form_reader
            cx_fp_ads_util INTO DATA(error).
        " Fail the test if exception occurs
        cl_abap_unit_assert=>fail(
            msg = |Exception of type { cl_abap_typedescr=>describe_by_data( error )->get_relative_name( ) } occurred: { error->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
