INTERFACE zif_pra_mf_gen_ai_util
  PUBLIC .

  TYPES: BEGIN OF llm_response_structure,
           title       TYPE zpra_mf_a_mf-title,
           description TYPE zpra_mf_a_mf-description,
         END OF llm_response_structure.

  CONSTANTS:
    BEGIN OF intelligent_scenario_gpt_4o,
      name       TYPE aic_islm_scenario_id=>type VALUE 'ZPRA_MF_GENAI_GPT_4O',
      temprature TYPE if_aic_completion_parameters=>temperature VALUE '0.4',
      max_tokens TYPE i VALUE '4096',
    END OF intelligent_scenario_gpt_4o.

  CONSTANTS:
    BEGIN OF desc_system_prompt,
      template_name TYPE aic_islm_prompt_template_id=>type VALUE 'DESC_SYSTEM_PROMPT',
    END OF desc_system_prompt.

  CONSTANTS:
    BEGIN OF add_rhyme_system_prompt,
      template_name TYPE aic_islm_prompt_template_id=>type VALUE 'ADD_RHYME_SYSTEM_PROMPT',
    END OF add_rhyme_system_prompt.

  CONSTANTS:
    BEGIN OF set_language_system_prompt,
      template_name    TYPE aic_islm_prompt_template_id=>type VALUE 'SET_LANGUAGE_USER_PROMPT',
      var_set_language TYPE if_aic_prompt_template=>param_value-value VALUE 'ISLM_LANG',
    END OF set_language_system_prompt.

  CLASS-METHODS get_instance
    RETURNING
      VALUE(result) TYPE REF TO  zif_pra_mf_gen_ai_util.

  METHODS generate_music_festival_data
    IMPORTING
      language        TYPE ZPRA_MF_AE_CreateMFWithAI-language
      tags            TYPE ZPRA_MF_AE_CreateMFWithAI-tags
      rhyme_indicator TYPE zpra_mf_ae_createmfwithai-rhyme
    RETURNING
      VALUE(result)   TYPE llm_response_structure
    RAISING
      cx_aic_api_factory
      cx_aic_completion_api
      cx_aic_prompt_template.
ENDINTERFACE.
