INTERFACE zif_pra_mf_com_util
  PUBLIC.
  METHODS is_scenario_configured
    IMPORTING scenario_id   TYPE if_com_arrangement_v2=>ty_ca-cscn_id
    RETURNING VALUE(result) TYPE abap_boolean.
ENDINTERFACE.
