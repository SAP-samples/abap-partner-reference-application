*"* use this source file for your ABAP unit test classes
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

    " specify test entity keys
    music_festival_keys = VALUE #( (  uuid = 'DEC190889AC21FE08191A45962D04217' ) ).

    READ ENTITY zpra_mf_r_musicfestival
         ALL FIELDS WITH CORRESPONDING #( music_festival_keys )
         RESULT DATA(music_festivals).

    READ TABLE music_festivals INTO DATA(music_festival) INDEX 1.

    " Assign the XML content to the string variable
    DATA(xml_string) =  |<?xml version="1.0" encoding="UTF-8"?>| &
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
         RESULT XML DATA(xml_xstring).

    rv_xml = xml_xstring.
  ENDMETHOD.

  METHOD if_fp_fdp_api~get_xsd.
  ENDMETHOD.

  METHOD if_fp_fdp_api~read_to_data.
  ENDMETHOD.

  METHOD if_fp_fdp_api~read_to_xml.
  ENDMETHOD.
ENDCLASS.


CLASS ltcl_pra_mf_bgmc_op_print_form DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA cut        TYPE REF TO zcl_pra_mf_bgmc_op_print_util.
    CLASS-DATA cut_reject TYPE REF TO zcl_pra_mf_bgmc_op_print_util.

    CONSTANTS application_service_def TYPE if_fp_fdp_api=>ty_service_definition VALUE 'ZPRA_MF_MUSICFESTIVAL'.
    CONSTANTS form_template           TYPE fpname                               VALUE 'ZPRA_MF_PDF_FORM_MF'.
    CONSTANTS pq_name                 TYPE cl_fp_ads_util=>ty_pq_name           VALUE 'DEFAULT'.
    CONSTANTS uuid                    TYPE sysuuid_x16                          VALUE 'DEC190889AC21FE08191A45962D04217'.

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.
    METHODS form_should_add_to_print_queue FOR TESTING.
    METHODS reject_fp_fdp_service          FOR TESTING.

ENDCLASS.

CLASS zcl_pra_mf_bgmc_op_print_util DEFINITION LOCAL FRIENDS ltcl_pra_mf_bgmc_op_print_form.

CLASS ltcl_pra_mf_bgmc_op_print_form IMPLEMENTATION.
  METHOD class_setup.
    cut = NEW zcl_pra_mf_bgmc_op_print_util( VALUE zcl_pra_mf_bgmc_op_print_util=>print_request_structure(
                                                       form_name   = form_template
                                                       print_queue = pq_name
                                                       uuid        = uuid
                                                       fdp_srvd    = application_service_def ) ).
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD form_should_add_to_print_queue.
    TRY.

        TEST-INJECTION create_pq.

        END-TEST-INJECTION.
        cut->fp_fdp_service = NEW ltcl_fp_fdp_glo_itf( ).
        cut->if_bgmc_op_single_tx_uncontr~execute( ).

      CATCH cx_bgmc_operation.
        cl_abap_unit_assert=>fail( ).
    ENDTRY.
  ENDMETHOD.

  METHOD reject_fp_fdp_service.
    TRY.
        cut_reject = NEW zcl_pra_mf_bgmc_op_print_util( VALUE zcl_pra_mf_bgmc_op_print_util=>print_request_structure(
                                                                  form_name   = form_template
                                                                  print_queue = pq_name
                                                                  uuid        = uuid
                                                                  fdp_srvd    = 'INVALID_SERVICE_DEFINITION' ) ).
        CLEAR cut_reject->fp_fdp_service.
        cut_reject->if_bgmc_op_single_tx_uncontr~execute( ).

      CATCH cx_bgmc_operation INTO DATA(bgmc_ex).
        " Verify the exception chain
        DATA(is_correct_previous) = COND abap_bool(
          WHEN bgmc_ex->previous IS BOUND
           AND bgmc_ex->previous IS INSTANCE OF cx_fp_fdp_error
          THEN abap_true
          ELSE abap_false ).

        cl_abap_unit_assert=>assert_true(
            act = is_correct_previous
            msg = COND #( WHEN bgmc_ex->previous IS NOT BOUND
                          THEN |cx_bgmc_operation has no previous exception|
                          ELSE |Previous exception is { cl_abap_typedescr=>describe_by_data( bgmc_ex->previous )->get_relative_name( ) }, expected cx_fp_fdp_error| ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
