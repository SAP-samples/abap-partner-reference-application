*"* use this source file for your ABAP unit test classes
CLASS ltc_pra_mf_fetch_proj DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO  zcl_pra_mf_ent_proj_outb_integ,
      cds_test_environment TYPE REF TO if_cds_test_environment,  " cds test double framework
      sql_test_environment TYPE REF TO if_osql_test_environment. " abap sql test double framework

    CLASS-METHODS:
      " setup test double framework
      class_setup,
      " stop test doubles
      class_teardown.

    METHODS:
      " reset test doubles
      setup,
      " rollback any changes
      teardown,
      create_entproject_neg_case1 FOR TESTING,
      create_entproject_neg_case2 FOR TESTING.

ENDCLASS.

CLASS ltc_pra_mf_fetch_proj IMPLEMENTATION.

  METHOD class_setup.

    CREATE OBJECT class_under_test.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD create_entproject_neg_case1.

    TEST-INJECTION execute_request.
      RAISE EXCEPTION TYPE /iwbep/cx_cp_remote.
    END-TEST-INJECTION.

    DATA: business_details     TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.

    business_details = VALUE #( profit_center               = 'YB900'
                             project                     = |MF_| && | TEST |
                             project_description         = 'Testing'
                             project_end_date            = sy-datum
                             project_profile_code        = 'YP02'
                             project_start_date          = sy-datum
                             responsible_cost_center     = 'CC_CON1' ).

    class_under_test->create_entproject( EXPORTING project_details_in  = business_details
                                         IMPORTING project_details_out = DATA(project_details)
                                                           messages = DATA(messages) ).

    cl_abap_unit_assert=>assert_initial( act = project_details ).
    cl_abap_unit_assert=>assert_not_initial( act = messages ).

  ENDMETHOD.

  METHOD create_entproject_neg_case2.

    TEST-INJECTION execute_request.
      RAISE EXCEPTION TYPE /iwbep/cx_gateway.
    END-TEST-INJECTION.

    DATA: business_details     TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.

    business_details = VALUE #( profit_center               = 'YB900'
                             project                     = |MF_| && | TEST |
                             project_description         = 'Testing'
                             project_end_date            = sy-datum
                             project_profile_code        = 'YP02'
                             project_start_date          = sy-datum
                             responsible_cost_center     = 'CC_CON1' ).

    class_under_test->create_entproject( EXPORTING project_details_in  = business_details
                                         IMPORTING project_details_out = DATA(project_details)
                                                           messages = DATA(messages) ).

    cl_abap_unit_assert=>assert_initial( act = project_details ).
    cl_abap_unit_assert=>assert_not_initial( act = messages ).

  ENDMETHOD.


ENDCLASS.
