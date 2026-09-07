"!@testing SRVB:ZPRA_MF_API_MUSICFESTIVAL
CLASS ltc_visitor_read DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA mo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy.
    DATA mv_existing_uuid TYPE sysuuid_x16.

    METHODS setup RAISING cx_static_check.

    " Read-Only Test Methods
    METHODS read_list      FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltc_visitor_read IMPLEMENTATION.

  METHOD setup.
    " Initialize Local Client Proxy
    mo_client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v4_local_proxy(
                          is_service_key     = VALUE #( service_id      = 'ZPRA_MF_API_MUSICFESTIVAL'
                                                        repository_id   = 'SRVD'
                                                        service_version = '0001' )
                          iv_do_write_traces = abap_true ).

    " Since we can't CREATE, we'll try to fetch one existing record to use for the single-read test
    DATA lt_list TYPE TABLE OF zpra_mf_c_visitor_api.
    TRY.
        DATA(lo_request) = mo_client_proxy->create_resource_for_entity_set( 'VISITOR' )->create_request_for_read( ).
        lo_request->set_top( 1 ).
        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_list ).

        IF lt_list IS NOT INITIAL.
          mv_existing_uuid = lt_list[ 1 ]-uuid.
        ENDIF.
      CATCH /iwbep/cx_cp_remote /iwbep/cx_gateway.
        " Setup remains silent; tests will skip if mv_existing_uuid is empty
    ENDTRY.
  ENDMETHOD.

  METHOD read_list.
    DATA lt_visitor_list TYPE TABLE OF zpra_mf_c_visitor_api.

    TRY.
        " Note: Using 'Visitor' to match your Swagger/Service Definition casing
        DATA(lo_request) = mo_client_proxy->create_resource_for_entity_set( 'VISITOR' )->create_request_for_read( ).
        lo_request->set_top( 5 ).

        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_visitor_list ).

        cl_abap_unit_assert=>assert_not_initial(
          act = lt_visitor_list ).

      CATCH /iwbep/cx_cp_remote /iwbep/cx_gateway INTO DATA(lx_exc).
        cl_abap_unit_assert=>fail( lx_exc->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


ENDCLASS.
