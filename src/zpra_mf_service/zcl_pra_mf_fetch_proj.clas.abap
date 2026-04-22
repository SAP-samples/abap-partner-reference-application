CLASS zcl_pra_mf_fetch_proj DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS ZCL_PRA_MF_FETCH_PROJ IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    TYPES : BEGIN OF project_details,
              Projectid   TYPE c LENGTH 24,
              ProjectName TYPE c LENGTH 40,
              StartDate   TYPE c LENGTH 8,
              EndDate     TYPE c LENGTH 8,
              CostCenter  TYPE c LENGTH 10,
              Status      TYPE c LENGTH 10,
              Nav         TYPE c LENGTH 120,
            END OF project_details.

    TYPES : BEGIN OF range,
              sign   TYPE c LENGTH 1,
              option TYPE c LENGTH 2,
              low    TYPE c LENGTH 24,
              high   TYPE c LENGTH 24,
            END OF range.
    TYPES ranges TYPE STANDARD TABLE OF range WITH EMPTY KEY.

    DATA http_client        TYPE REF TO if_web_http_client.
    DATA client_proxy       TYPE REF TO /iwbep/if_cp_client_proxy.
    DATA s4_project_details TYPE TABLE OF zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.
    DATA project_details    TYPE TABLE OF project_details.
    DATA request            TYPE REF TO /iwbep/if_cp_request_read_list.
    DATA ca_range           TYPE if_com_scenario_factory=>ty_query-cscn_id_range.
    DATA gateway_error      TYPE REF TO /iwbep/cx_gateway.
    DATA url                TYPE string.
    DATA message            TYPE string.
    DATA comm_arrang        TYPE STANDARD TABLE OF REF TO if_com_arrangement.

    CONSTANTS project_constant TYPE string VALUE 'ui#EnterpriseProject-planProject?EnterpriseProject='.

    CLEAR ca_range.
    " find Communication Arrangement by scenario ID
    ca_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZPRA_MF_CS_ENT_PROJ' ) ).

    TEST-SEAM comm_arrang. "#EC TEST_SEAM_USAGE
      DATA(factory) = cl_com_arrangement_factory=>create_instance( ).
      factory->query_ca( EXPORTING is_query           = VALUE #( cscn_id_range = ca_range  )
                         IMPORTING et_com_arrangement = comm_arrang ).
    END-TEST-SEAM.

    IF comm_arrang IS INITIAL.
      io_response->set_data( it_data = project_details ).
      io_response->set_total_number_of_records( 0 ).
      RETURN.
    ELSE.
      ASSIGN comm_arrang[ 1 ] TO FIELD-SYMBOL(<fs_ca>).
      IF sy-subrc = 0.
        DATA(inb_services)  = <fs_ca>->get_inbound_services( ).
        DATA(outb_services) = <fs_ca>->get_outbound_services( ).

        IF outb_services IS NOT INITIAL.
          url = outb_services[ 1 ]-url.
          url = |{ url }{ project_constant }|.
        ENDIF.
      ENDIF.

    ENDIF.

    TRY.
        "  Get the destination of remote system; Create http client
        DATA(destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario  = 'ZPRA_MF_CS_ENT_PROJ'
                                comm_system_id = 'TEST_SAP_COM_0308_PRA_2'
                                service_id     = 'ZPRA_MF_OUT_ENT_PROJ_REST' ).

        IF destination IS BOUND.

          TEST-SEAM http_client. "#EC TEST_SEAM_USAGE
            http_client = cl_web_http_client_manager=>create_by_http_destination( destination ).
          END-TEST-SEAM.

          IF http_client IS BOUND.
            " create client proxy
            client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                               is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                                   proxy_model_id      = 'ZCL_PRA_MF_SCM_ENT_PROJ'
                                                                   proxy_model_version = '001' )
                               io_http_client           = http_client
                               iv_relative_service_root = '/sap/opu/odata/sap/API_ENTERPRISE_PROJECT_SRV;v=0002/' ). " = the service endpoint in the service binding in PRV' ).

          ENDIF.
        ENDIF.

      CATCH cx_http_dest_provider_error INTO DATA(provider_error).
        MESSAGE e009(zpra_mf_msg_cls) INTO message.
      CATCH /iwbep/cx_gateway INTO gateway_error.
        MESSAGE e009(zpra_mf_msg_cls) INTO message.
      CATCH cx_web_http_client_error INTO DATA(http_client_error).
        MESSAGE e009(zpra_mf_msg_cls) INTO message.
    ENDTRY.

    TRY.
        IF client_proxy IS BOUND.
          request = client_proxy->create_resource_for_entity_set( 'A_ENTERPRISE_PROJECT' )->create_request_for_read( ).

          DATA(filters) = io_request->get_filter( ).
          IF filters IS NOT BOUND.
            RETURN.
          ENDIF.

          TRY.
              DATA(ranges) = filters->get_as_ranges( ).
            CATCH cx_rap_query_filter_no_range INTO DATA(range_error).
              RETURN.
          ENDTRY.

          request->set_filter( io_filter_node = request->create_filter_factory( )->create_by_range(
                                                    iv_property_path = 'PROJECT'
                                                    it_range         = ranges[ 1 ]-range ) ).

          TEST-SEAM execute_request. "#EC TEST_SEAM_USAGE
            request->execute( ).

            DATA(response) = request->get_response( ).

            response->get_business_data( IMPORTING et_business_data = s4_project_details ).
          END-TEST-SEAM.

        ENDIF.
      CATCH /iwbep/cx_cp_remote INTO DATA(remote_error).
        MESSAGE e009(zpra_mf_msg_cls) INTO message.
      CATCH /iwbep/cx_gateway INTO gateway_error.
        MESSAGE e009(zpra_mf_msg_cls) INTO message.
    ENDTRY.

    LOOP AT s4_project_details ASSIGNING FIELD-SYMBOL(<s4_project_details>).
      project_details = VALUE #(
          BASE project_details
          ( projectid   = <s4_project_details>-project
            projectname = <s4_project_details>-project_description
            startdate   = <s4_project_details>-project_start_date
            enddate     = <s4_project_details>-project_end_date
            costcenter  = <s4_project_details>-responsible_cost_center
            status      = COND #( WHEN <s4_project_details>-processing_status = '00' THEN 'Created' )
            Nav         = |{ url }{ <s4_project_details>-project }| ) ).
    ENDLOOP.
    io_response->set_data( it_data = project_details ).
    io_response->set_total_number_of_records( CONV int8( lines( project_details ) ) ).
  ENDMETHOD.
ENDCLASS.
