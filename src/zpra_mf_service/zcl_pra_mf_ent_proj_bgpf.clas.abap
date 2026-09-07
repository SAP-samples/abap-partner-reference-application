CLASS zcl_pra_mf_ent_proj_bgpf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_bgmc_op_single.

    CLASS-METHODS create_object
      IMPORTING
                project_data_in      TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type OPTIONAL
      RETURNING VALUE(ent_proj_bgpf) TYPE REF TO zcl_pra_mf_ent_proj_bgpf.

    DATA project_details_instance TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.

  PRIVATE SECTION.
    CLASS-DATA ent_proj_bgpf_pvt TYPE REF TO zcl_pra_mf_ent_proj_bgpf.

ENDCLASS.



CLASS zcl_pra_mf_ent_proj_bgpf IMPLEMENTATION.


  METHOD create_object.
    IF ent_proj_bgpf_pvt IS NOT BOUND.
      CREATE OBJECT ent_proj_bgpf.
      ent_proj_bgpf_pvt = ent_proj_bgpf.
    ELSE.
      ent_proj_bgpf = ent_proj_bgpf_pvt.
    ENDIF.
  ENDMETHOD.


  METHOD if_bgmc_op_single~execute.

    TYPES BEGIN OF ty_business_details.
    INCLUDE TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.
    TYPES to_enterprise_project_el_2 TYPE zcl_pra_mf_scm_ent_proj=>tyt_a_enterprise_project_ele_2.
    TYPES END OF ty_business_details.

    DATA:
      header_properties TYPE TABLE OF string,
      business_details  TYPE ty_business_details,
      request           TYPE REF TO /iwbep/if_cp_request_create,
      response          TYPE REF TO /iwbep/if_cp_response_create,
      child_properties  TYPE TABLE OF string,
      client_proxy      TYPE REF TO /iwbep/if_cp_client_proxy,
      http_client       TYPE REF TO if_web_http_client,
      error_handle      TYPE balloghndl,
      update_mf         TYPE TABLE FOR UPDATE zpra_mf_r_musicfestival.

    CHECK project_details_instance IS NOT INITIAL.

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
                             project                     = |MF_| && |{ project_details_instance-project }|
                             project_description         =
                             COND #( WHEN project_details_instance-project_description IS NOT INITIAL
                             THEN project_details_instance-project_description
                             ELSE project_details_instance-project )
                             project_end_date            = project_details_instance-project_end_date
                             project_profile_code        = 'YP02'
                             project_start_date          = project_details_instance-project_start_date
                             responsible_cost_center     = 'CC_CON1' ).

    TRY.
        "  Get the destination of remote system; Create http client
        TEST-SEAM http_dest_provider_error.
          DATA(destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                                      comm_scenario  = 'ZPRA_MF_CS_ENT_PROJ'
                                                      comm_system_id = 'TEST_SAP_COM_0308_PRA_2'
                                                       service_id     = 'ZPRA_MF_OUT_ENT_PROJ_REST' ).
        END-TEST-SEAM.
        http_client = cl_web_http_client_manager=>create_by_http_destination( destination ).

        "create client proxy
        client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                        proxy_model_id      = 'ZCL_PRA_MF_SCM_ENT_PROJ'
                                                        proxy_model_version = '001' )
                    io_http_client             = http_client
                    iv_relative_service_root   = '/sap/opu/odata/sap/API_ENTERPRISE_PROJECT_SRV;v=0002/'  " = the service endpoint in the service binding in PRV' ).
                    ).

        IF client_proxy IS BOUND.
          DATA(proj_resource) = client_proxy->create_resource_for_entity_set( 'A_ENTERPRISE_PROJECT' ).
          IF proj_resource IS BOUND.
            TEST-SEAM request.
              request = proj_resource->create_request_for_create( ).
            END-TEST-SEAM.
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

        IF request IS BOUND.
          TEST-SEAM execute_request.
            response = request->execute( ).
          END-TEST-SEAM.

          CLEAR update_mf.
          APPEND VALUE #(
            uuid       = project_details_instance-project_uuid
            is_project_created = abap_true
            %control   = VALUE #(
              is_project_created = if_abap_behv=>mk-on )
          ) TO update_mf.

          MODIFY ENTITIES OF zpra_mf_r_musicfestival
            ENTITY MusicFestival
            UPDATE FROM update_mf
            FAILED   DATA(failed_mf)
            REPORTED DATA(reported_mf).

        ELSE.

          CLEAR update_mf.
          error_handle = log_handle.
          APPEND VALUE #(
            uuid       = project_details_instance-project_uuid
            is_project_created = abap_FALSE
            project_log_handle = error_handle
            is_project_crea_trig = abap_false
            %control   = VALUE #(
              is_project_created = if_abap_behv=>mk-on
              project_log_handle = if_abap_behv=>mk-on
              is_project_crea_trig = if_abap_behv=>mk-on
               )
          ) TO update_mf.

          MODIFY ENTITIES OF zpra_mf_r_musicfestival
            ENTITY MusicFestival
            UPDATE FROM update_mf
            FAILED   failed_mf
            REPORTED reported_mf.

        ENDIF.

      CATCH cx_root INTO DATA(root_error).
        APPEND VALUE #(
          uuid       = project_details_instance-project_uuid
          is_project_created = abap_false
          project_log_handle = log_handle
          is_project_crea_trig = abap_false
          %control   = VALUE #(
            is_project_created = if_abap_behv=>mk-on
            project_log_handle = if_abap_behv=>mk-on
            is_project_crea_trig = if_abap_behv=>mk-on )
        ) TO update_mf.

        MODIFY ENTITIES OF zpra_mf_r_musicfestival
          ENTITY MusicFestival
          UPDATE FROM update_mf
          FAILED   failed_mf
          REPORTED reported_mf.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
