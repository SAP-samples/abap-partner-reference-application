CLASS ltcl_zcl_pra_mf_gen_ai_util DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA: sut      TYPE REF TO zcl_pra_mf_gen_ai_util.

    METHODS:
      setup,
      teardown,
      return_service_instance          FOR TESTING,
      return_schema                    FOR TESTING,
      parse_json_to_struct             FOR TESTING,
      build_sys_prompt_no_rhyme        FOR TESTING,
      build_sys_prompt_with_rhyme      FOR TESTING,
      build_user_prompt_with_input     FOR TESTING,
      create_api_instance              FOR TESTING,
      generate_mf_data                 FOR TESTING.

ENDCLASS.

CLASS zcl_pra_mf_gen_ai_util DEFINITION LOCAL FRIENDS ltcl_zcl_pra_mf_gen_ai_util.

CLASS ltcl_zcl_pra_mf_gen_ai_util IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT sut.
  ENDMETHOD.

  METHOD teardown.
    CLEAR sut.
  ENDMETHOD.

  METHOD return_service_instance.

    DATA(ai_service) = sut->get_instance( ).
    cl_abap_unit_assert=>assert_true( act = xsdbool( ai_service IS INSTANCE OF zif_pra_mf_gen_ai_util )
                                      msg = 'Invalid instance creation for Class' ).

  ENDMETHOD.

  METHOD return_schema.
    DATA(schema) = sut->get_llm_response_json_schema( ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( schema CS '"title": { "type": "string", "maxLength": 100' )
      msg = 'Schema should contain title' ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( schema CS '"description": { "type": "string", "maxLength": 500' )
      msg = 'Schema should contain description' ).
  ENDMETHOD.

  METHOD parse_json_to_struct.
    DATA(json) = `{"title":"Test Fest","description":"A fun music festival"}`.
    DATA(result) = sut->convert_llm_response_json_abap( json ).
    cl_abap_unit_assert=>assert_equals(
      act = result-title
      exp = 'Test Fest'
      msg = 'Title mismatch' ).
    cl_abap_unit_assert=>assert_equals(
      act = result-description
      exp = 'A fun music festival'
      msg = 'Description mismatch' ).
  ENDMETHOD.

  METHOD build_sys_prompt_no_rhyme.
    TRY.
        DATA(prompt) = sut->get_mf_data_gen_sys_prompt(
          enable_desc_rhyme = abap_false ).
        DATA(desc_prompt) = sut->get_mf_prompt( template_id = zif_pra_mf_gen_ai_util=>desc_system_prompt-template_name ).
      CATCH cx_aic_api_factory cx_aic_prompt_template INTO DATA(exception).
        cl_abap_unit_assert=>fail( msg = | 'API call failed unexpectedly' { exception->get_text(  ) }| ).
    ENDTRY.
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( prompt CS desc_prompt )
      msg = 'Prompt should include rhyme' ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( NOT ( prompt CS 'written in rhymes' ) )
      msg = 'Prompt should not include rhyme' ).
  ENDMETHOD.

  METHOD build_sys_prompt_with_rhyme.
    TRY.
        DATA(prompt) = sut->get_mf_data_gen_sys_prompt(
          enable_desc_rhyme = abap_true ).

        DATA(desc_prompt) = sut->get_mf_prompt( template_id = zif_pra_mf_gen_ai_util=>desc_system_prompt-template_name ).
      CATCH cx_aic_api_factory cx_aic_prompt_template INTO DATA(exception).
        cl_abap_unit_assert=>fail( msg = | 'API call failed unexpectedly' { exception->get_text(  ) }| ).
    ENDTRY.
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( prompt CS desc_prompt )
      msg = 'Prompt should include rhyme' ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( prompt CS 'written in rhymes' )
      msg = 'Prompt should include rhyme' ).
  ENDMETHOD.

  METHOD create_api_instance.
    TRY.
        DATA(api) = sut->get_completion_api_gpt_4o( ).
        cl_abap_unit_assert=>assert_bound(
          act = api
          msg = 'API instance should be returned' ).
      CATCH cx_aic_api_factory INTO DATA(lx).
        cl_abap_unit_assert=>fail( msg = lx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD generate_mf_data.

    TRY.
        DATA(result) = sut->zif_pra_mf_gen_ai_util~generate_music_festival_data(
          tags            = 'rock, outdoor'
          rhyme_indicator = abap_true
          language        = 'EN' ).
      CATCH cx_aic_api_factory cx_aic_completion_api cx_aic_prompt_template INTO DATA(exception).
        cl_abap_unit_assert=>fail( msg = | 'API call failed unexpectedly' { exception->get_text(  ) }| ).
    ENDTRY.

    cl_abap_unit_assert=>assert_not_initial( result ).
    cl_abap_unit_assert=>assert_not_initial( result-title ).
    cl_abap_unit_assert=>assert_not_initial( result-description ).

  ENDMETHOD.

  METHOD build_user_prompt_with_input.
    TRY.
        DATA(prompt) = sut->get_mf_data_gen_user_prompt(
          language = 'FR'
          tags     = 'rock, outdoor' ).
      CATCH cx_aic_api_factory cx_aic_prompt_template INTO DATA(exception).
        cl_abap_unit_assert=>fail( msg = | 'API call failed unexpectedly' { exception->get_text(  ) }| ).
    ENDTRY.

    cl_abap_unit_assert=>assert_true(
      act = xsdbool( prompt CS 'Language: FR' )
      msg = 'Prompt should include FR language' ).

    cl_abap_unit_assert=>assert_true(
      act = xsdbool( prompt CS 'Tags: rock, outdoor' )
      msg = 'Prompt should include tags' ).
  ENDMETHOD.

ENDCLASS.
