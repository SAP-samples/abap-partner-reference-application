CLASS zcl_pra_mf_fetch_proj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_pra_mf_fetch_proj IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    TYPES : BEGIN OF lty_data,
              Projectid   TYPE c LENGTH 24,
              ProjectName TYPE c LENGTH 40,
              StartDate   TYPE c LENGTH 8,
              EndDate     TYPE c LENGTH 8,
              CostCenter  TYPE c LENGTH 10,
              Status      TYPE c LENGTH 10,
              Nav         TYPE c LENGTH 120,
            END OF lty_data.

    TYPES : BEGIN OF lty_range,
              sign   TYPE c LENGTH 1,
              option TYPE c LENGTH 2,
              low    TYPE c LENGTH 24,
              high   TYPE c LENGTH 24,
            END OF lty_range,
            ltt_range TYPE STANDARD TABLE OF lty_range WITH EMPTY KEY.

    DATA:
      lo_http_client  TYPE REF TO if_web_http_client,
      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      lt_data         TYPE TABLE OF zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type,
      lt_data1        TYPE TABLE OF lty_data,
      lo_request      TYPE REF TO /iwbep/if_cp_request_read_list,
      lr_cscn         TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

    CONSTANTS : lc_project TYPE string VALUE 'ui#EnterpriseProject-planProject?EnterpriseProject='.

    CLEAR : lr_cscn.
    " find Communication Arrangement by scenario ID
    lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZPRA_MF_CS_ENT_PROJ' ) ).

    DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).lo_factory->query_ca(
  EXPORTING
    is_query = VALUE #( cscn_id_range = lr_cscn )
  IMPORTING
    et_com_arrangement = DATA(lt_ca) ).

    IF lt_ca IS INITIAL.
      EXIT.
    ELSE.
      READ TABLE lt_ca ASSIGNING FIELD-SYMBOL(<fs_ca>) INDEX 1.
      IF sy-subrc EQ 0.
        DATA(lt_inb_services)  = <fs_ca>->get_inbound_services( ).
        DATA(lt_outb_services) = <fs_ca>->get_outbound_services( ).

        IF lt_outb_services IS NOT INITIAL.
          DATA(lv_url) = lt_outb_services[ 1 ]-url.
          lv_url = lv_url && lc_project.
        ENDIF.
      ENDIF.

    ENDIF.

    TRY.
        "  Get the destination of remote system; Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                                    comm_scenario  = 'ZPRA_MF_CS_ENT_PROJ'
                                                    comm_system_id = 'TEST_SAP_COM_0308_PRA_2'
                                                     service_id     = 'ZPRA_MF_OUT_ENT_PROJ_REST'
    ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        "create client proxy
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                        proxy_model_id      = 'ZCL_PRA_MF_SCM_ENT_PROJ'
                                                        proxy_model_version = '001' )
                    io_http_client             = lo_http_client
                    iv_relative_service_root   = '/sap/opu/odata/sap/API_ENTERPRISE_PROJECT_SRV;v=0002/'  " = the service endpoint in the service binding in PRV' ).
                    ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_prov_error).
        MESSAGE e009(zpra_mf_msg_cls) INTO DATA(lv_msg).
      CATCH /iwbep/cx_gateway INTO DATA(lx_cx_gateway).
        MESSAGE e009(zpra_mf_msg_cls) INTO lv_msg.
      CATCH cx_web_http_client_error INTO DATA(lx_http_client).
        MESSAGE e009(zpra_mf_msg_cls) INTO lv_msg.
    ENDTRY.

    TRY.
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_ENTERPRISE_PROJECT' )->create_request_for_read( ).

        lo_request->set_filter(
                  io_filter_node = lo_request->create_filter_factory( )->create_by_range(
                    iv_property_path = 'PROJECT'
                    it_range         = VALUE ltt_range( ( sign = 'I' option = 'CP' low = 'MF_*' high = '' ) )
                  )
                ).

        lo_request->execute( ).


        DATA(lo_response) = lo_request->get_response( ).

        lo_response->get_business_data( IMPORTING et_business_data = lt_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        MESSAGE e009(zpra_mf_msg_cls) INTO lv_msg.
      CATCH /iwbep/cx_gateway INTO DATA(lo_exception).
        MESSAGE e009(zpra_mf_msg_cls) INTO lv_msg.
    ENDTRY.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
      lt_data1 = VALUE #( BASE lt_data1 (
                                          projectid = <lfs_data>-project
                                          projectname = <lfs_data>-project_description
                                          startdate = <lfs_data>-project_start_date
                                          enddate = <lfs_data>-project_end_date
                                          costcenter = <lfs_data>-responsible_cost_center
                                          status = COND #( WHEN <lfs_data>-processing_status EQ '00' THEN 'Created' )
                                          Nav = lv_url && <lfs_data>-project

                                           ) ).
    ENDLOOP.
    io_response->set_data( it_data = lt_data1 ).
    io_response->set_total_number_of_records( CONV int8( lines( lt_data1 ) ) ).

  ENDMETHOD.
ENDCLASS.
