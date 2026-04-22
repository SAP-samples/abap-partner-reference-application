"! @testing zcl_pra_mf_calc_visit_elements
CLASS ltcl_calc_visit_elements DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    TYPES tt_calc_elements TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.

    CLASS-DATA cut                  TYPE REF TO zcl_pra_mf_calc_visit_elements.
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.
    METHODS cancelled_returns_negative     FOR TESTING.
    METHODS pending_returns_critical       FOR TESTING.
    METHODS booked_returns_positive        FOR TESTING.
    METHODS unknown_returns_neutral        FOR TESTING.
    METHODS empty_returns_neutral          FOR TESTING.
    METHODS calc_criticality_booked        FOR TESTING RAISING cx_static_check.
    METHODS calc_criticality_cancelled     FOR TESTING RAISING cx_static_check.
    METHODS calc_multiple_visits           FOR TESTING RAISING cx_static_check.
    METHODS get_calc_info_status_criticlty FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_wrong_entity     FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_unknown_element  FOR TESTING RAISING cx_sadl_exit.
ENDCLASS.

CLASS zcl_pra_mf_calc_visit_elements DEFINITION LOCAL FRIENDS ltcl_calc_visit_elements.

CLASS ltcl_calc_visit_elements IMPLEMENTATION.
  METHOD class_setup.
    cut = NEW #( ).
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                               i_for_entities = VALUE #( ( i_for_entity = 'ZPRA_MF_C_VISITTP' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    CLEAR cut.
    IF cds_test_environment IS BOUND.
      cds_test_environment->destroy( ).
    ENDIF.
  ENDMETHOD.

  METHOD setup.
    IF cds_test_environment IS BOUND.
      cds_test_environment->clear_doubles( ).
    ENDIF.
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD cancelled_returns_negative.
    cl_abap_unit_assert=>assert_equals(
        exp = zcl_pra_mf_enum_criticality=>negative
        act = zcl_pra_mf_calc_visit_elements=>calculate_status_criticality( zcl_pra_mf_enum_visit_status=>cancelled ) ).
  ENDMETHOD.

  METHOD pending_returns_critical.
    cl_abap_unit_assert=>assert_equals(
        exp = zcl_pra_mf_enum_criticality=>critical
        act = zcl_pra_mf_calc_visit_elements=>calculate_status_criticality( zcl_pra_mf_enum_visit_status=>pending ) ).
  ENDMETHOD.

  METHOD booked_returns_positive.
    cl_abap_unit_assert=>assert_equals(
        exp = zcl_pra_mf_enum_criticality=>positive
        act = zcl_pra_mf_calc_visit_elements=>calculate_status_criticality( zcl_pra_mf_enum_visit_status=>booked ) ).
  ENDMETHOD.

  METHOD unknown_returns_neutral.
    DATA status TYPE zpra_mf_c_visittp-status VALUE 'X'.

    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>neutral
                                        act = zcl_pra_mf_calc_visit_elements=>calculate_status_criticality( status ) ).
  ENDMETHOD.

  METHOD empty_returns_neutral.
    DATA status TYPE zpra_mf_c_visittp-status VALUE ''.

    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>neutral
                                        act = zcl_pra_mf_calc_visit_elements=>calculate_status_criticality( status ) ).
  ENDMETHOD.

  METHOD calc_criticality_booked.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_visittp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_visittp.

    APPEND VALUE #( status = zcl_pra_mf_enum_visit_status=>booked ) TO original_data.
    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    READ TABLE calculated_data INTO DATA(result) INDEX 1.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>positive
                                        act = result-StatusCriticality ).
  ENDMETHOD.

  METHOD calc_criticality_cancelled.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_visittp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_visittp.

    APPEND VALUE #( status = zcl_pra_mf_enum_visit_status=>cancelled ) TO original_data.
    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    READ TABLE calculated_data INTO DATA(result) INDEX 1.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>negative
                                        act = result-StatusCriticality ).
  ENDMETHOD.

  METHOD calc_multiple_visits.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_visittp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_visittp.

    APPEND VALUE #( status = zcl_pra_mf_enum_visit_status=>booked )  TO original_data.
    APPEND VALUE #( status = zcl_pra_mf_enum_visit_status=>pending ) TO original_data.
    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = lines( calculated_data ) ).

    READ TABLE calculated_data INTO DATA(first) INDEX 1.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>positive
                                        act = first-StatusCriticality ).

    READ TABLE calculated_data INTO DATA(second) INDEX 2.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>critical
                                        act = second-StatusCriticality ).
  ENDMETHOD.

  METHOD get_calc_info_status_criticlty.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info( EXPORTING iv_entity                  = `ZPRA_MF_C_VISITTP`
                                                                        it_requested_calc_elements = calc_elements
                                                              IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_equals( exp = 1
                                        act = lines( result ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `STATUS` ] ) ) ).
  ENDMETHOD.

  METHOD get_calc_info_wrong_entity.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info( EXPORTING iv_entity                  = `SOME_OTHER_ENTITY`
                                                                        it_requested_calc_elements = calc_elements
                                                              IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_initial( act = result ).
  ENDMETHOD.

  METHOD get_calc_info_unknown_element.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `UNKNOWNELEMENT` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info( EXPORTING iv_entity                  = `ZPRA_MF_C_VISITTP`
                                                                        it_requested_calc_elements = calc_elements
                                                              IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_initial( act = result ).
  ENDMETHOD.
ENDCLASS.
