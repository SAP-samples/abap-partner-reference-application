INTERFACE zif_pra_mf_ent_proj_integ PUBLIC.

  TYPES: BEGIN OF clientproxy_result,
           client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
           messages     TYPE bapirettab,
         END OF clientproxy_result.

  TYPES: BEGIN OF create_project_result,
           project_details TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type,
           messages        TYPE bapirettab,
         END OF create_project_result.

  METHODS get_clientproxy
    RETURNING VALUE(result) TYPE clientproxy_result.

  METHODS create_entproject
    IMPORTING
      project_details_in TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type
    RETURNING
      VALUE(result)      TYPE create_project_result.

ENDINTERFACE.
