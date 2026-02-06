CLASS zcl_pra_mf_gen_ai_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_pra_mf_gen_ai_util.
    ALIASES:  get_instance FOR zif_pra_mf_gen_ai_util~get_instance,
              generate_music_festival_data FOR zif_pra_mf_gen_ai_util~generate_music_festival_data,
              intelligent_scenario_gpt_4o FOR zif_pra_mf_gen_ai_util~intelligent_scenario_gpt_4o,
              desc_system_prompt FOR zif_pra_mf_gen_ai_util~desc_system_prompt,
              add_rhyme_system_prompt FOR zif_pra_mf_gen_ai_util~add_rhyme_system_prompt,
              set_language_system_prompt FOR zif_pra_mf_gen_ai_util~set_language_system_prompt.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA instance TYPE REF TO zif_pra_mf_gen_ai_util.

    METHODS get_mf_data_gen_sys_prompt
      IMPORTING
        enable_desc_rhyme TYPE abap_bool
      RETURNING
        VALUE(result)     TYPE string
      RAISING
        cx_aic_api_factory
        cx_aic_prompt_template.

    METHODS get_mf_data_gen_user_prompt
      IMPORTING
        language      TYPE ZPRA_MF_AE_CreateMFWithAI-language
        tags          TYPE ZPRA_MF_AE_CreateMFWithAI-tags
      RETURNING
        VALUE(result) TYPE string
      RAISING
        cx_aic_api_factory
        cx_aic_prompt_template.

    METHODS get_completion_api_gpt_4o
      RETURNING
        VALUE(result) TYPE REF TO if_aic_completion_api
      RAISING
        cx_aic_api_factory.

    METHODS get_mf_prompt
      IMPORTING
        template_id   TYPE aic_islm_prompt_template_id=>type
        parameters    TYPE if_aic_prompt_template=>param_values OPTIONAL
      RETURNING
        VALUE(result) TYPE string
      RAISING
        cx_aic_api_factory
        cx_aic_prompt_template.

    METHODS convert_llm_response_json_abap
      IMPORTING
        llm_response_json TYPE string
      RETURNING
        VALUE(result)     TYPE zif_pra_mf_gen_ai_util~llm_response_structure.

    METHODS get_llm_response_json_schema
      RETURNING
        VALUE(result) TYPE string.


ENDCLASS.

CLASS zcl_pra_mf_gen_ai_util IMPLEMENTATION.

  METHOD zif_pra_mf_gen_ai_util~get_instance.

    IF instance IS INITIAL.
      instance = NEW zcl_pra_mf_gen_ai_util( ).
    ENDIF.
    result = instance.

  ENDMETHOD.


  METHOD zif_pra_mf_gen_ai_util~generate_music_festival_data.

    DATA(completion_api) = get_completion_api_gpt_4o( ).
    FINAL(messages) = completion_api->create_message_container( ).
    messages->set_system_role( get_mf_data_gen_sys_prompt( enable_desc_rhyme = rhyme_indicator ) ).
    messages->add_user_message( get_mf_data_gen_user_prompt( language = language
                                                             tags     = tags ) ).

    completion_api->define_response_format( )->json_schema( )->from_string( get_llm_response_json_schema( ) ).

    FINAL(llm_response_json) = completion_api->execute_for_messages( messages )->get_completion( ).

    result = convert_llm_response_json_abap( llm_response_json ).

  ENDMETHOD.

  METHOD get_completion_api_gpt_4o.
    result = cl_aic_islm_compl_api_factory=>get( )->create_instance( intelligent_scenario_gpt_4o-name ).
    FINAL(parameter_setter) = result->get_parameter_setter( ).
    parameter_setter->set_temperature( intelligent_scenario_gpt_4o-temprature ).
    parameter_setter->set_maximum_tokens( intelligent_scenario_gpt_4o-max_tokens ).
  ENDMETHOD.

  METHOD get_mf_data_gen_sys_prompt.

    result = get_mf_prompt( template_id = desc_system_prompt-template_name ).

    IF enable_desc_rhyme = abap_true.
      DATA rhyme_prompt TYPE string.
      rhyme_prompt    = get_mf_prompt( template_id = add_rhyme_system_prompt-template_name ).
      result = | { result } { cl_abap_char_utilities=>newline } { rhyme_prompt } |.
    ENDIF.
  ENDMETHOD.

  METHOD get_mf_data_gen_user_prompt.

    DATA lang_prompt TYPE string.
    lang_prompt = get_mf_prompt( template_id = set_language_system_prompt-template_name
                                 parameters  = VALUE #( ( name  = set_language_system_prompt-var_set_language
                                                          value = language ) ) ).


    result =  |tags: { tags }  { cl_abap_char_utilities=>newline } { lang_prompt } |.

  ENDMETHOD.

  METHOD get_mf_prompt.
    result = cl_aic_islm_prompt_tpl_factory=>get( )->create_instance( islm_scenario = intelligent_scenario_gpt_4o-name
                                                                      template_id   = template_id
                                                                     )->get_prompt( parameters ).
  ENDMETHOD.


  METHOD get_llm_response_json_schema.
    result = |\{ "type": "object",| &&
                              |"properties": \{ "title": \{ "type": "string", "maxLength": 100 \},| &&
                              |"description": \{ "type": "string", "maxLength": 500 \} \},| &&
                              |"additionalProperties": false, "required": [ "title", "description" ] \}| ##NO_TEXT.
  ENDMETHOD.


  METHOD convert_llm_response_json_abap.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = llm_response_json
      CHANGING
        data = result
    ).

  ENDMETHOD.

ENDCLASS.
