*"* use this source file for your ABAP unit test classes
CLASS ltc_pra_mf_fetch_proj DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA class_under_test     TYPE REF TO zcl_pra_mf_ent_proj_outb_integ.
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.        " cds test double framework
    CLASS-DATA sql_test_environment TYPE REF TO if_osql_test_environment.       " abap sql test double framework

    " setup test double framework
    CLASS-METHODS class_setup.
    " stop test doubles
    CLASS-METHODS class_teardown.

    " reset test doubles
    METHODS setup.
    " rollback any changes
    METHODS teardown.
    METHODS create_entproject_neg_case1 FOR TESTING.
    METHODS create_entproject_neg_case2 FOR TESTING.

ENDCLASS.


CLASS ltc_pra_mf_fetch_proj IMPLEMENTATION.
  METHOD class_setup.
    class_under_test = NEW #( ).
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD create_entproject_neg_case1.
    TEST-INJECTION execute_request.
      RAISE EXCEPTION NEW /iwbep/cx_cp_remote( ).
    END-TEST-INJECTION.

    DATA business_details TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.

    business_details = VALUE #( profit_center           = 'YB900'
                                project                 = |MF_ TEST |
                                project_description     = 'Testing'
                                project_end_date        = sy-datum
                                project_profile_code    = 'YP02'
                                project_start_date      = sy-datum
                                responsible_cost_center = 'CC_CON1' ).

DATA(result) = class_under_test->zif_pra_mf_ent_proj_integ~create_entproject(
      project_details_in = business_details ).


    cl_abap_unit_assert=>assert_initial( act = result-project_details ).
    cl_abap_unit_assert=>assert_not_initial( act = result-messages ).
  ENDMETHOD.

  METHOD create_entproject_neg_case2.
    TEST-INJECTION execute_request.
      RAISE EXCEPTION NEW /iwbep/cx_gateway( ).
    END-TEST-INJECTION.

    DATA business_details TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.

    business_details = VALUE #( profit_center           = 'YB900'
                                project                 = |MF_ TEST |
                                project_description     = 'Testing'
                                project_end_date        = sy-datum
                                project_profile_code    = 'YP02'
                                project_start_date      = sy-datum
                                responsible_cost_center = 'CC_CON1' ).

    DATA(result) = class_under_test->zif_pra_mf_ent_proj_integ~create_entproject(
                       project_details_in = business_details ).

    cl_abap_unit_assert=>assert_initial( act = result-project_details ).
    cl_abap_unit_assert=>assert_not_initial( act = result-messages ).
  ENDMETHOD.
ENDCLASS.
