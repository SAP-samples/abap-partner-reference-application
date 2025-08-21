CLASS zcl_pra_mf_ent_proj_outb_integ DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES BEGIN OF ty_business_data.
    INCLUDE TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.
    TYPES to_enterprise_project_el_2 TYPE zcl_pra_mf_scm_ent_proj=>tyt_a_enterprise_project_ele_2.
    TYPES END OF ty_business_data.

    METHODS get_clientproxy
      EXPORTING
                et_message             TYPE bapirettab
      RETURNING VALUE(ro_client_proxy) TYPE REF TO /iwbep/if_cp_client_proxy.

    METHODS create_entproject
      IMPORTING
        Is_project_data TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type
      EXPORTING
        es_project_data TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type
        et_message      TYPE bapirettab.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRA_MF_ENT_PROJ_OUTB_INTEG IMPLEMENTATION.


  METHOD create_entproject.

    TYPES BEGIN OF ty_business_data.
    INCLUDE TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.
    TYPES to_enterprise_project_el_2 TYPE zcl_pra_mf_scm_ent_proj=>tyt_a_enterprise_project_ele_2.
    TYPES END OF ty_business_data.

    DATA:
      lo_http_client    TYPE REF TO if_web_http_client,
      lt_header_pro     TYPE TABLE OF string,
      ls_business_data  TYPE ty_business_data,
      lo_client_proxy   TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request        TYPE REF TO /iwbep/if_cp_request_create,
      lo_response       TYPE REF TO /iwbep/if_cp_response_create,
      lo_resource       TYPE REF TO /iwbep/if_cp_resource_entity,
      lo_filter_factory TYPE REF TO /iwbep/if_cp_filter_factory,
      lt_gl_pro         TYPE TABLE OF string,
      lo_filter_node_1  TYPE REF TO /iwbep/if_cp_filter_node.


    APPEND 'PROFIT_CENTER'               TO lt_header_pro.
    APPEND 'PROJECT'                     TO lt_header_pro.
    APPEND 'PROJECT_DESCRIPTION'         TO lt_header_pro.
    APPEND 'PROJECT_END_DATE'            TO lt_header_pro.
    APPEND 'PROJECT_PROFILE_CODE'        TO lt_header_pro.
    APPEND 'PROJECT_START_DATE'          TO lt_header_pro.
    APPEND 'RESPONSIBLE_COST_CENTER'     TO lt_header_pro.
    APPEND 'PROJECT_ELEMENT'               TO lt_gl_pro.
    APPEND 'PROJECT_ELEMENT_DESCRIPT_2'    TO lt_gl_pro.
    APPEND 'PLANNED_START_DATE'            TO lt_gl_pro.
    APPEND 'PLANNED_END_DATE'              TO lt_gl_pro.

    ls_business_data = VALUE #( profit_center               = 'YB900'
                                project                     = |MF_| && |{ is_project_data-project }|
                                project_description         = is_project_data-project_description
                                project_end_date            = is_project_data-project_end_date
                                project_profile_code        = 'YP02'
                                project_start_date          = is_project_data-project_start_date
                                responsible_cost_center     = 'CC_CON1' ).

    TRY.

        lo_request = get_clientproxy( )->create_resource_for_entity_set( 'A_ENTERPRISE_PROJECT' )->create_request_for_create( ).
        DATA(lo_data_description_node) = lo_request->create_data_descripton_node( ).

        lo_data_description_node->set_properties( lt_header_pro  ).

        DATA(lo_item_child) = lo_data_description_node->add_child( 'TO_ENTERPRISE_PROJECT_EL_2' ).
        lo_item_child->set_properties( lt_gl_pro ).
        lo_request->set_deep_business_data( is_business_data = ls_business_data
                                            io_data_description = lo_data_description_node ).

      CATCH /iwbep/cx_gateway INTO DATA(lo_exception).
        et_message = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
    ENDTRY.

    TRY.
        " Execute the request
        lo_response = lo_request->execute( ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        et_message = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        et_message = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_clientproxy.

    DATA:
      lo_http_client  TYPE REF TO if_web_http_client,
      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy.

    TRY.
        "  Get the destination of remote system; Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                                    comm_scenario  = 'ZPRA_MF_CS_ENT_PROJ'
                                                    comm_system_id = 'TEST_SAP_COM_0308_PRA_2'
                                                     service_id     = 'ZPRA_MF_OUT_ENT_PROJ_REST'
    ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        "create client proxy
        ro_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                        proxy_model_id      = 'ZCL_PRA_MF_SCM_ENT_PROJ'
                                                        proxy_model_version = '001' )
                    io_http_client             = lo_http_client
                    iv_relative_service_root   = '/sap/opu/odata/sap/API_ENTERPRISE_PROJECT_SRV;v=0002/'  " = the service endpoint in the service binding in PRV' ).
                    ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_prov_error).
        et_message = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
      CATCH /iwbep/cx_gateway INTO DATA(lx_cx_gateway).
        et_message = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
      CATCH cx_web_http_client_error INTO DATA(lx_http_client).
        et_message = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA ls_project_data TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.

        create_entproject( EXPORTING is_project_data = ls_project_data IMPORTING es_project_data  = ls_project_data ) .

  ENDMETHOD.


  METHOD if_rap_query_provider~select.
  ENDMETHOD.
ENDCLASS.
