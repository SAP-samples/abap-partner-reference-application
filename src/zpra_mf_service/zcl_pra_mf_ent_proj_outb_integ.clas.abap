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
      EXPORTING messages            TYPE bapirettab
      RETURNING VALUE(client_proxy) TYPE REF TO /iwbep/if_cp_client_proxy.

    METHODS create_entproject
      IMPORTING
        project_details_in  TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type
      EXPORTING
        project_details_out TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type
        messages            TYPE bapirettab.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_pra_mf_ent_proj_outb_integ IMPLEMENTATION.


  METHOD create_entproject.

    TYPES BEGIN OF ty_business_details.
    INCLUDE TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.
    TYPES to_enterprise_project_el_2 TYPE zcl_pra_mf_scm_ent_proj=>tyt_a_enterprise_project_ele_2.
    TYPES END OF ty_business_details.

    DATA:
      header_properties TYPE TABLE OF string,
      business_details  TYPE ty_business_details,
      request           TYPE REF TO /iwbep/if_cp_request_create,
      response          TYPE REF TO /iwbep/if_cp_response_create,
      child_properties  TYPE TABLE OF string.

    APPEND 'PROFIT_CENTER'               TO header_properties.
    APPEND 'PROJECT'                     TO header_properties.
    APPEND 'PROJECT_DESCRIPTION'         TO header_properties.
    APPEND 'PROJECT_END_DATE'            TO header_properties.
    APPEND 'PROJECT_PROFILE_CODE'        TO header_properties.
    APPEND 'PROJECT_START_DATE'          TO header_properties.
    APPEND 'RESPONSIBLE_COST_CENTER'     TO header_properties.
    APPEND 'PROJECT_ELEMENT'             TO child_properties.
    APPEND 'PROJECT_ELEMENT_DESCRIPT_2'  TO child_properties.
    APPEND 'PLANNED_START_DATE'          TO child_properties.
    APPEND 'PLANNED_END_DATE'            TO child_properties.

    business_details = VALUE #( profit_center            = 'YB900'
                             project                     = |MF_| && |{ project_details_in-project }|
                             project_description         = project_details_in-project_description
                             project_end_date            = project_details_in-project_end_date
                             project_profile_code        = 'YP02'
                             project_start_date          = project_details_in-project_start_date
                             responsible_cost_center     = 'CC_CON1' ).

    TRY.

*        request = get_clientproxy( )->create_resource_for_entity_set( 'A_ENTERPRISE_PROJECT' )->create_request_for_create( ).
        DATA(client_proxy) = get_clientproxy( ).
        IF client_proxy IS BOUND.
          DATA(proj_resource) = client_proxy->create_resource_for_entity_set( 'A_ENTERPRISE_PROJECT' ).
          IF proj_resource IS BOUND.
            request = proj_resource->create_request_for_create( ).

            IF request IS BOUND.
              DATA(data_description_node) = request->create_data_descripton_node( ).

              data_description_node->set_properties( header_properties  ).

              DATA(item_child) = data_description_node->add_child( 'TO_ENTERPRISE_PROJECT_EL_2' ).
              item_child->set_properties( child_properties ).
              request->set_deep_business_data( is_business_data = business_details
                                               io_data_description = data_description_node ).
            ENDIF.
          ENDIF.
        ENDIF.

      CATCH /iwbep/cx_gateway INTO DATA(gateway_error).
        messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
    ENDTRY.

    TRY.
        " Execute the request
        IF request IS BOUND.
          TEST-SEAM execute_request.
            response = request->execute( ).
          END-TEST-SEAM.
        ELSE.
          messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(remote_error).
        messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
      CATCH /iwbep/cx_gateway INTO gateway_error.
        messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_clientproxy.

    DATA: http_client  TYPE REF TO if_web_http_client.

    TRY.
        "  Get the destination of remote system; Create http client
        DATA(destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                                    comm_scenario  = 'ZPRA_MF_CS_ENT_PROJ'
                                                    comm_system_id = 'TEST_SAP_COM_0308_PRA_2'
                                                     service_id     = 'ZPRA_MF_OUT_ENT_PROJ_REST'
    ).
        http_client = cl_web_http_client_manager=>create_by_http_destination( destination ).

        "create client proxy
        client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                        proxy_model_id      = 'ZCL_PRA_MF_SCM_ENT_PROJ'
                                                        proxy_model_version = '001' )
                    io_http_client             = http_client
                    iv_relative_service_root   = '/sap/opu/odata/sap/API_ENTERPRISE_PROJECT_SRV;v=0002/'  " = the service endpoint in the service binding in PRV' ).
                    ).

      CATCH cx_http_dest_provider_error INTO DATA(provider_error).
        messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
      CATCH /iwbep/cx_gateway INTO DATA(cx_gateway_error).
        messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
      CATCH cx_web_http_client_error INTO DATA(http_client_error).
        messages = VALUE #( ( type = 'E' id = 'ZPRA_MF_MSG_CLS' number = '009' ) ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
