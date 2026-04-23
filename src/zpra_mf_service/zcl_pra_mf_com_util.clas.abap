CLASS zcl_pra_mf_com_util DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_pra_mf_com_util.
ENDCLASS.



CLASS ZCL_PRA_MF_COM_UTIL IMPLEMENTATION.


  METHOD zif_pra_mf_com_util~is_scenario_configured.
    " we determine if the input scenario is configured or not based on whether there is
    " an active Communication Arrangement present for the scenario
    " in backend there is no status at CA level, it is rather at the outbound service level
    " No status for inbound service so we are checking the inbound service configured or not based on the service url

    cl_com_arrangement_factory=>create_instance( )->query_ca(
      EXPORTING is_query           = VALUE #( cscn_id_range = VALUE #( ( sign   = cl_abap_range=>sign-including
                                                                         option = cl_abap_range=>option-equal
                                                                         low    = scenario_id ) ) )
      IMPORTING et_com_arrangement = DATA(com_arrangements) ).

    LOOP AT com_arrangements INTO DATA(com_arrangement).
      DATA(outbound_services) = com_arrangement->get_outbound_services( ).
      IF line_exists( outbound_services[ status = if_com_arrangement_v2=>co_service_status-active ] ).
        result = abap_true.
        RETURN.
      ENDIF.

      DATA(inbound_services) = com_arrangement->get_inbound_services( ).
      LOOP AT inbound_services INTO DATA(inbound_service).
        IF inbound_service-urls IS NOT INITIAL.
          result = abap_true.
          RETURN.
        ENDIF.
      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
