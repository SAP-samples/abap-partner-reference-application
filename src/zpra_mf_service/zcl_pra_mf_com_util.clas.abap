CLASS zcl_pra_mf_com_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS  is_scenario_configured
      IMPORTING scenario_id       TYPE if_com_arrangement_v2=>ty_ca-cscn_id
      RETURNING VALUE(result) TYPE abap_boolean.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_pra_mf_com_util IMPLEMENTATION.

  METHOD is_scenario_configured.
    " we determine if the input scenario is configured or not based on whether there is
    " an active Communication Arrangement present for the scenario

    cl_com_arrangement_factory=>create_instance( )->query_ca(
                                                      EXPORTING
                                                        is_query = VALUE #( cscn_id_range = VALUE #(
                                                                              (   sign    = cl_abap_range=>sign-including
                                                                                  option  = cl_abap_range=>option-equal
                                                                                  low     = scenario_id ) ) )
                                                      IMPORTING
                                                        et_com_arrangement = DATA(com_arrangements) ).

    LOOP AT com_arrangements INTO DATA(com_arrangement).
      " in backend there is no status at CA level, it is rather at the outbound service level
      DATA(outbound_services) = com_arrangement->get_outbound_services( ).
      IF line_exists( outbound_services[ status = if_com_arrangement_v2=>co_service_status-active ] ).
        result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
