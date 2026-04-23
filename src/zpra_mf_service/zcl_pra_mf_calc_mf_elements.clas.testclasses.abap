CLASS ltd_form_util DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES zif_pra_mf_form_util PARTIALLY IMPLEMENTED.

    DATA raise_error TYPE abap_bool.
    DATA pdf_result  TYPE zpra_mf_c_musicfestivaltp-outputpdfdata VALUE 'DUMMYPDF'.
ENDCLASS.


CLASS ltd_form_util IMPLEMENTATION.
  METHOD zif_pra_mf_form_util~get_fp_fdp_service.
    result = CAST #( cl_abap_testdouble=>create( 'IF_FP_FDP_API' ) ).
  ENDMETHOD.

  METHOD zif_pra_mf_form_util~render_form_for_preview.
    IF raise_error = abap_true.
      RAISE EXCEPTION NEW cx_fp_fdp_error( ).
    ENDIF.
    result = pdf_result.
  ENDMETHOD.
ENDCLASS.


"! @testing zcl_pra_mf_calc_mf_elements
CLASS ltcl_calc_mf_elements DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    TYPES tt_calc_elements TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.

    CLASS-DATA cut                  TYPE REF TO zcl_pra_mf_calc_mf_elements.
    CLASS-DATA cds_test_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.
    METHODS cancelled_returns_negative     FOR TESTING.
    METHODS fully_bkd_returns_critical     FOR TESTING.
    METHODS published_returns_positive     FOR TESTING.
    METHODS unknown_returns_neutral        FOR TESTING.
    METHODS empty_returns_neutral          FOR TESTING.
    METHODS calc_booked_seats              FOR TESTING RAISING cx_static_check.
    METHODS calc_mimetype                  FOR TESTING RAISING cx_static_check.
    METHODS calc_hyperlink_text            FOR TESTING RAISING cx_static_check.
    METHODS calc_multiple_elements         FOR TESTING RAISING cx_static_check.
    METHODS get_calc_info_booked_seats     FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_status_criticlty FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_output_pdf       FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_mimetype         FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_hyperlink        FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_multiple_elems   FOR TESTING RAISING cx_sadl_exit.
    METHODS get_calc_info_wrong_entity     FOR TESTING RAISING cx_sadl_exit.
    METHODS calc_pdf_happy_path            FOR TESTING RAISING cx_static_check.
    METHODS calc_pdf_form_error            FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_pra_mf_calc_mf_elements DEFINITION LOCAL FRIENDS ltcl_calc_mf_elements.

CLASS ltcl_calc_mf_elements IMPLEMENTATION.
  METHOD class_setup.
    cut = NEW #( ).
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                               i_for_entities = VALUE #( ( i_for_entity = 'ZPRA_MF_C_MUSICFESTIVALTP' ) ) ).
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
    CLEAR cut->form_util.
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD cancelled_returns_negative.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>negative
                                        act = cut->calculate_event_status_ind( zcl_pra_mf_enum_mf_status=>cancelled ) ).
  ENDMETHOD.

  METHOD fully_bkd_returns_critical.
    cl_abap_unit_assert=>assert_equals(
        exp = zcl_pra_mf_enum_criticality=>critical
        act = cut->calculate_event_status_ind( zcl_pra_mf_enum_mf_status=>fully_booked ) ).
  ENDMETHOD.

  METHOD published_returns_positive.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>positive
                                        act = cut->calculate_event_status_ind( zcl_pra_mf_enum_mf_status=>published ) ).
  ENDMETHOD.

  METHOD unknown_returns_neutral.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>neutral
                                        act = cut->calculate_event_status_ind( 'X' ) ).
  ENDMETHOD.

  METHOD empty_returns_neutral.
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>neutral
                                        act = cut->calculate_event_status_ind( '' ) ).
  ENDMETHOD.

  METHOD calc_booked_seats.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.

    APPEND VALUE #( maxvisitorsnumber = 100
                    freevisitorseats  = 30 ) TO original_data.
    INSERT `BOOKEDSEATS` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    READ TABLE calculated_data INTO DATA(result) INDEX 1.
    cl_abap_unit_assert=>assert_equals( exp = 70
                                        act = result-BookedSeats ).
  ENDMETHOD.

  METHOD calc_mimetype.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.

    APPEND VALUE #( ) TO original_data.
    INSERT `MIMETYPE` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    READ TABLE calculated_data INTO DATA(result) INDEX 1.
    cl_abap_unit_assert=>assert_equals( exp = 'application/pdf'
                                        act = result-mimetype ).
  ENDMETHOD.

  METHOD calc_hyperlink_text.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.

    APPEND VALUE #( title = 'Rock Festival 2024' ) TO original_data.
    INSERT `HYPERLINKTEXT` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    READ TABLE calculated_data INTO DATA(result) INDEX 1.
    cl_abap_unit_assert=>assert_equals( exp = 'Rock Festival 2024'
                                        act = result-hyperlinktext ).
  ENDMETHOD.

  METHOD calc_multiple_elements.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.

    APPEND VALUE #( title             = 'Jazz Festival'
                    maxvisitorsnumber = 200
                    freevisitorseats  = 50
                    status            = zcl_pra_mf_enum_mf_status=>fully_booked ) TO original_data.
    INSERT `BOOKEDSEATS`       INTO TABLE calc_elements.
    INSERT `HYPERLINKTEXT`     INTO TABLE calc_elements.
    INSERT `MIMETYPE`          INTO TABLE calc_elements.
    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    READ TABLE calculated_data INTO DATA(result) INDEX 1.
    cl_abap_unit_assert=>assert_equals( exp = 150
                                        act = result-bookedseats ).
    cl_abap_unit_assert=>assert_equals( exp = zcl_pra_mf_enum_criticality=>critical
                                        act = result-statuscriticality ).
    cl_abap_unit_assert=>assert_equals( exp = 'application/pdf'
                                        act = result-mimetype ).
    cl_abap_unit_assert=>assert_equals( exp = 'Jazz Festival'
                                        act = result-hyperlinktext ).
  ENDMETHOD.

  METHOD get_calc_info_booked_seats.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `BOOKEDSEATS` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info(
      EXPORTING iv_entity                  = `ZPRA_MF_C_MUSICFESTIVALTP`
                it_requested_calc_elements = calc_elements
      IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = lines( result ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `MAXVISITORSNUMBER` ] ) ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `FREEVISITORSEATS` ] ) ) ).
  ENDMETHOD.

  METHOD get_calc_info_status_criticlty.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info(
      EXPORTING iv_entity                  = `ZPRA_MF_C_MUSICFESTIVALTP`
                it_requested_calc_elements = calc_elements
      IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_equals( exp = 1
                                        act = lines( result ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `STATUS` ] ) ) ).
  ENDMETHOD.

  METHOD get_calc_info_output_pdf.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `OUTPUTPDFDATA` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info(
      EXPORTING iv_entity                  = `ZPRA_MF_C_MUSICFESTIVALTP`
                it_requested_calc_elements = calc_elements
      IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_equals( exp = 1
                                        act = lines( result ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `UUID` ] ) ) ).
  ENDMETHOD.

  METHOD get_calc_info_mimetype.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `MIMETYPE` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info(
      EXPORTING iv_entity                  = `ZPRA_MF_C_MUSICFESTIVALTP`
                it_requested_calc_elements = calc_elements
      IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_initial( act = result ).
  ENDMETHOD.

  METHOD get_calc_info_hyperlink.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `HYPERLINKTEXT` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info(
      EXPORTING iv_entity                  = `ZPRA_MF_C_MUSICFESTIVALTP`
                it_requested_calc_elements = calc_elements
      IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_initial( act = result ).
  ENDMETHOD.

  METHOD get_calc_info_multiple_elems.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `BOOKEDSEATS`       INTO TABLE calc_elements.
    INSERT `OUTPUTPDFDATA`     INTO TABLE calc_elements.
    INSERT `STATUSCRITICALITY` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info(
      EXPORTING iv_entity                  = `ZPRA_MF_C_MUSICFESTIVALTP`
                it_requested_calc_elements = calc_elements
      IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_equals( exp = 4
                                        act = lines( result ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `MAXVISITORSNUMBER` ] ) ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `FREEVISITORSEATS` ] ) ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `STATUS` ] ) ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( line_exists( result[ table_line = `UUID` ] ) ) ).
  ENDMETHOD.

  METHOD get_calc_info_wrong_entity.
    DATA calc_elements TYPE tt_calc_elements.

    INSERT `BOOKEDSEATS` INTO TABLE calc_elements.

    cut->if_sadl_exit_calc_element_read~get_calculation_info( EXPORTING iv_entity                  = `SOME_OTHER_ENTITY`
                                                                        it_requested_calc_elements = calc_elements
                                                              IMPORTING et_requested_orig_elements = DATA(result) ).

    cl_abap_unit_assert=>assert_initial( act = result ).
  ENDMETHOD.

  METHOD calc_pdf_happy_path.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.

    APPEND VALUE #( uuid = cl_system_uuid=>create_uuid_x16_static( ) ) TO original_data.
    INSERT `OUTPUTPDFDATA` INTO TABLE calc_elements.

    cut->form_util = NEW ltd_form_util( ).

    cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                             it_requested_calc_elements = calc_elements
                                                   CHANGING  ct_calculated_data         = calculated_data ).

    READ TABLE calculated_data INTO DATA(result) INDEX 1.
    cl_abap_unit_assert=>assert_not_initial( act = result-outputpdfdata ).
  ENDMETHOD.

  METHOD calc_pdf_form_error.
    DATA original_data   TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.
    DATA calc_elements   TYPE tt_calc_elements.
    DATA calculated_data TYPE STANDARD TABLE OF zpra_mf_c_musicfestivaltp.

    APPEND VALUE #( uuid = cl_system_uuid=>create_uuid_x16_static( ) ) TO original_data.
    INSERT `OUTPUTPDFDATA` INTO TABLE calc_elements.

    DATA(double) = NEW ltd_form_util( ).
    double->raise_error = abap_true.
    cut->form_util = double.

    TRY.
        cut->if_sadl_exit_calc_element_read~calculate( EXPORTING it_original_data           = original_data
                                                                 it_requested_calc_elements = calc_elements
                                                       CHANGING  ct_calculated_data         = calculated_data ).
        cl_abap_unit_assert=>fail( ).

      CATCH zcx_pra_mf_calc_exit INTO DATA(calc_exit).
        cl_abap_unit_assert=>assert_bound( act = calc_exit->previous ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
