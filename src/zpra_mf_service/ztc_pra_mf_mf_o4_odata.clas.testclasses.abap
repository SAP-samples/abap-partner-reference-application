"!@testing SRVB:ZPRA_MF_API_MUSICFESTIVAL
CLASS ltc_musicfestival_crud DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA client_proxy TYPE REF TO /iwbep/if_cp_client_proxy.

    DATA created_uuid TYPE sysuuid_x16.

    CLASS-METHODS class_setup RAISING cx_static_check.
    CLASS-METHODS class_teardown RAISING cx_static_check.

    METHODS setup.
    METHODS teardown.

    METHODS test_create_festival FOR TESTING RAISING cx_static_check.
    METHODS test_read_festival   FOR TESTING RAISING cx_static_check.
    METHODS test_read_list       FOR TESTING RAISING cx_static_check.
    METHODS test_update_festival FOR TESTING RAISING cx_static_check.
    METHODS test_delete_festival FOR TESTING RAISING cx_static_check.

    METHODS create_test_festival
      IMPORTING iv_title        TYPE string
                iv_description  TYPE string DEFAULT 'Test Description'
                iv_max_visitors TYPE i DEFAULT 100
      RETURNING VALUE(result)  TYPE zpra_mf_c_musicfestival_api
      RAISING   cx_static_check.

    METHODS delete_festival_by_uuid
      IMPORTING iv_uuid TYPE sysuuid_x16.

ENDCLASS.

CLASS ltc_musicfestival_crud IMPLEMENTATION.

  METHOD class_setup.
    client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v4_local_proxy(
      is_service_key     = VALUE #( service_id      = 'ZPRA_MF_API_MUSICFESTIVAL'
                                    repository_id   = 'SRVD'
                                    service_version = '0001' )
      iv_do_write_traces = abap_true ).
  ENDMETHOD.

  METHOD class_teardown.
    CLEAR client_proxy.
  ENDMETHOD.

  METHOD setup.
    CLEAR created_uuid.
  ENDMETHOD.

  METHOD teardown.
    IF created_uuid IS NOT INITIAL.
      delete_festival_by_uuid( created_uuid ).
    ENDIF.
  ENDMETHOD.

  METHOD create_test_festival.
    DATA business_data TYPE zpra_mf_c_musicfestival_api.

    business_data = VALUE #(
      title             = iv_title
      description       = iv_description
      eventdatetime     = utclong_add( val = utclong_current( ) days = 5 )
      maxvisitorsnumber = iv_max_visitors
      visitorsfeeamount = 25 ).

    DATA(request) = client_proxy->create_resource_for_entity_set( 'MUSICFESTIVAL' )->create_request_for_create( ).
    request->set_business_data( business_data ).
    DATA(response) = request->execute( ).
    response->get_business_data( IMPORTING es_business_data = result ).
  ENDMETHOD.

  METHOD delete_festival_by_uuid.
    TRY.
        DATA entity_key TYPE zpra_mf_c_musicfestival_api.
        entity_key = VALUE #( uuid = iv_uuid ).
        DATA(resource) = client_proxy->create_resource_for_entity_set( 'MUSICFESTIVAL' )->navigate_with_key( entity_key ).
        resource->create_request_for_delete( )->execute( ).
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD test_create_festival.
    TRY.
        DATA(created_data) = create_test_festival(
          iv_title        = 'Rock Fest Evolution Create Test'
          iv_description  = 'Main Stage Live Arena Performance'
          iv_max_visitors = 500 ).

        created_uuid = created_data-uuid.

        cl_abap_unit_assert=>assert_not_initial( act = created_data-uuid msg = 'UUID should be generated' ).
        cl_abap_unit_assert=>assert_equals( exp = 'Rock Fest Evolution Create Test' act = created_data-title ).
        cl_abap_unit_assert=>assert_equals( exp = 500 act = created_data-maxvisitorsnumber ).

      CATCH cx_root INTO DATA(error).
        cl_abap_unit_assert=>fail( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_read_festival.
    TRY.
        DATA(created_data) = create_test_festival( iv_title = 'Jazz Blues Open Air Read Test' ).
        created_uuid = created_data-uuid.

        DATA entity_key TYPE zpra_mf_c_musicfestival_api.
        entity_key = VALUE #( uuid = created_data-uuid ).

        DATA(resource) = client_proxy->create_resource_for_entity_set( 'MUSICFESTIVAL' )->navigate_with_key( entity_key ).
        DATA(response) = resource->create_request_for_read( )->execute( ).

        DATA read_data TYPE zpra_mf_c_musicfestival_api.
        response->get_business_data( IMPORTING es_business_data = read_data ).

        cl_abap_unit_assert=>assert_equals( exp = created_data-uuid act = read_data-uuid ).
        cl_abap_unit_assert=>assert_equals( exp = 'Jazz Blues Open Air Read Test' act = read_data-title ).

      CATCH cx_root INTO DATA(error).
        cl_abap_unit_assert=>fail( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_read_list.
    TRY.
        DATA(created_data) = create_test_festival( iv_title = 'Electronic Beats List Test' ).
        created_uuid = created_data-uuid.

        DATA(request) = client_proxy->create_resource_for_entity_set( 'MUSICFESTIVAL' )->create_request_for_read( ).
        request->set_top( 50 ).

        DATA list_data TYPE TABLE OF zpra_mf_c_musicfestival_api.
        DATA(response) = request->execute( ).
        response->get_business_data( IMPORTING et_business_data = list_data ).

        cl_abap_unit_assert=>assert_not_initial( act = list_data ).
        DATA(found) = xsdbool( line_exists( list_data[ uuid = created_data-uuid ] ) ).
        cl_abap_unit_assert=>assert_true( act = found msg = 'Test record not found in list' ).

      CATCH cx_root INTO DATA(error).
        cl_abap_unit_assert=>fail( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_update_festival.
    TRY.
        DATA(created_data) = create_test_festival( iv_title = 'Indie Soundwave Update Test' ).
        created_uuid = created_data-uuid.

        DATA entity_key TYPE zpra_mf_c_musicfestival_api.
        entity_key = VALUE #( uuid = created_data-uuid ).

        DATA patch_data TYPE zpra_mf_c_musicfestival_api.
        patch_data = VALUE #( title = 'Symphonic Metal Updated' ).

        DATA(resource) = client_proxy->create_resource_for_entity_set( 'MUSICFESTIVAL' )->navigate_with_key( entity_key ).
        DATA(request) = resource->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-patch ).
        request->set_business_data( is_business_data = patch_data it_provided_property = VALUE #( ( `TITLE` ) ) ).

        DATA updated_data TYPE zpra_mf_c_musicfestival_api.
        DATA(response) = request->execute( ).
        response->get_business_data( IMPORTING es_business_data = updated_data ).

        cl_abap_unit_assert=>assert_equals( exp = created_data-uuid act = updated_data-uuid ).
        cl_abap_unit_assert=>assert_equals( exp = 'Symphonic Metal Updated' act = updated_data-title ).

      CATCH cx_root INTO DATA(error).
        cl_abap_unit_assert=>fail( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_delete_festival.
    DATA test_uuid       TYPE sysuuid_x16.
    DATA delete_executed TYPE abap_bool VALUE abap_false.

    TRY.
        DATA(created_data) = create_test_festival( iv_title = 'Pop Anthem Delete Test' ).
        test_uuid = created_data-uuid.

        DATA entity_key TYPE zpra_mf_c_musicfestival_api.
        entity_key = VALUE #( uuid = test_uuid ).

        DATA(resource) = client_proxy->create_resource_for_entity_set( 'MUSICFESTIVAL' )->navigate_with_key( entity_key ).
        resource->create_request_for_delete( )->execute( ).
        delete_executed = abap_true.

      CATCH cx_root INTO DATA(delete_error).
        cl_abap_unit_assert=>fail( delete_error->get_text( ) ).
    ENDTRY.

    IF delete_executed = abap_true.
      TRY.
          DATA verify_key TYPE zpra_mf_c_musicfestival_api.
          verify_key = VALUE #( uuid = test_uuid ).
          DATA(read_resource) = client_proxy->create_resource_for_entity_set( 'MUSICFESTIVAL' )->navigate_with_key( verify_key ).
          read_resource->create_request_for_read( )->execute( ).
          cl_abap_unit_assert=>fail( 'Record should not exist after deletion' ).
        CATCH cx_root.
          cl_abap_unit_assert=>assert_true( act = abap_true ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

