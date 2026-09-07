INTERFACE zif_pra_mf_com_util
  PUBLIC.

  METHODS is_scenario_configured
    IMPORTING scenario_id   TYPE if_com_arrangement_v2=>ty_ca-cscn_id
    RETURNING VALUE(result) TYPE abap_boolean.

    METHODS get_host_from_comm_arrangement
      IMPORTING iv_scenario   TYPE if_com_arrangement_v2=>ty_ca-cscn_id
      RETURNING VALUE(result) TYPE string
      RAISING   cx_static_check cx_dynamic_check.



    METHODS get_host_from_comm_system
      IMPORTING iv_system_id  TYPE if_com_system=>ty_cs-id
      RETURNING VALUE(result) TYPE string
      RAISING   cx_static_check cx_dynamic_check.


ENDINTERFACE.
