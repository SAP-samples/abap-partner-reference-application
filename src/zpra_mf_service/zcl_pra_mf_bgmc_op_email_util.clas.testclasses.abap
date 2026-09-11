*"* use this source file for your ABAP unit test classes

"! @testing zcl_pra_mf_bgmc_op_email_util
CLASS ltcl_pra_mf_email_util DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA cut TYPE REF TO zcl_pra_mf_bgmc_op_email_util.

    CONSTANTS visitor_name    TYPE zpra_mf_name VALUE 'Jane Doe'.
    CONSTANTS email_address   TYPE c LENGTH 512 VALUE 'jane.doe@example.com'.
    CONSTANTS email_subject   TYPE c LENGTH 1024 VALUE 'Your booking confirmation'.
    CONSTANTS message_body    TYPE c LENGTH 1000 VALUE 'Thank you for booking with us.'.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.
    METHODS setup.
    METHODS teardown.
    METHODS constructor_stores_input   FOR TESTING RAISING cx_static_check.
    METHODS execute_succeeds_when_sent FOR TESTING RAISING cx_static_check.
    METHODS bcs_error_raises_bgmc_op   FOR TESTING RAISING cx_static_check.
    METHODS bgmc_op_has_retry_config   FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS zcl_pra_mf_bgmc_op_email_util DEFINITION LOCAL FRIENDS ltcl_pra_mf_email_util.

CLASS ltcl_pra_mf_email_util IMPLEMENTATION.

  METHOD class_setup.
    cut = NEW zcl_pra_mf_bgmc_op_email_util(
              email_input_data = VALUE zcl_pra_mf_bgmc_op_email_util=>email_request_structure(
                                           visitor_name  = visitor_name
                                           email_address = email_address
                                           subject       = email_subject
                                           message_body  = message_body ) ).
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD constructor_stores_input.
    " constructor copies all email_request fields without loss
    cl_abap_unit_assert=>assert_equals(
        exp = visitor_name
        act = cut->email_request-visitor_name ).
    cl_abap_unit_assert=>assert_equals(
        exp = email_address
        act = cut->email_request-email_address ).
    cl_abap_unit_assert=>assert_equals(
        exp = email_subject
        act = cut->email_request-subject ).
    cl_abap_unit_assert=>assert_equals(
        exp = message_body
        act = cut->email_request-message_body ).
  ENDMETHOD.

  METHOD execute_succeeds_when_sent.
    " execute succeeds when BCS send is stubbed out
    TRY.
        TEST-INJECTION send_mail.
        END-TEST-INJECTION.
        cut->if_bgmc_op_single_tx_uncontr~execute( ).
      CATCH cx_bgmc_operation.
        cl_abap_unit_assert=>fail( ).
    ENDTRY.
  ENDMETHOD.

  METHOD bcs_error_raises_bgmc_op.
    " cx_bcs_mail is caught and re-raised as cx_bgmc_operation
    DATA bgmc_ex TYPE REF TO cx_bgmc_operation.
    TRY.
        TEST-INJECTION send_mail.
          RAISE EXCEPTION NEW cx_bcs_mail( ).
        END-TEST-INJECTION.
        cut->if_bgmc_op_single_tx_uncontr~execute( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_bgmc_operation INTO bgmc_ex.
        cl_abap_unit_assert=>assert_bound( act = bgmc_ex->previous ).
        cl_abap_unit_assert=>assert_true(
            act = xsdbool( bgmc_ex->previous IS INSTANCE OF cx_bcs_mail ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD bgmc_op_has_retry_config.
    " re-raised cx_bgmc_operation enables retry with 5-second delay
    DATA bgmc_ex TYPE REF TO cx_bgmc_operation.
    TRY.
        TEST-INJECTION send_mail.
          RAISE EXCEPTION NEW cx_bcs_mail( ).
        END-TEST-INJECTION.
        cut->if_bgmc_op_single_tx_uncontr~execute( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_bgmc_operation INTO bgmc_ex.
        cl_abap_unit_assert=>assert_equals(
            exp = abap_true
            act = bgmc_ex->retry_settings-do_retry ).
        cl_abap_unit_assert=>assert_equals(
            exp = 5
            act = bgmc_ex->retry_settings-delay_time ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
"! @testing zcl_pra_mf_bgmc_op_email_util
CLASS ltcl_escape_html DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS ampersand_encoded     FOR TESTING.
    METHODS less_than_encoded     FOR TESTING.
    METHODS greater_than_encoded  FOR TESTING.
    METHODS double_quote_encoded  FOR TESTING.
    METHODS single_quote_encoded  FOR TESTING.
    METHODS plain_text_unchanged  FOR TESTING.
    METHODS empty_input_unchanged FOR TESTING.
    METHODS all_special_combined  FOR TESTING.
ENDCLASS.

CLASS ltcl_escape_html IMPLEMENTATION.

  METHOD ampersand_encoded.
    " & is replaced with &amp;
    cl_abap_unit_assert=>assert_equals(
        exp = 'a&amp;b'
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( 'a&b' ) ).
  ENDMETHOD.

  METHOD less_than_encoded.
    " < is replaced with &lt;
    cl_abap_unit_assert=>assert_equals(
        exp = '&lt;tag'
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( '<tag' ) ).
  ENDMETHOD.

  METHOD greater_than_encoded.
    " > is replaced with &gt;
    cl_abap_unit_assert=>assert_equals(
        exp = 'tag&gt;'
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( 'tag>' ) ).
  ENDMETHOD.

  METHOD double_quote_encoded.
    " double-quote is replaced with &quot;
    cl_abap_unit_assert=>assert_equals(
        exp = '&quot;value&quot;'
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( '"value"' ) ).
  ENDMETHOD.

  METHOD single_quote_encoded.
    " single-quote is replaced with &#39;
    cl_abap_unit_assert=>assert_equals(
        exp = |&#39;value&#39;|
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( |'value'| ) ).
  ENDMETHOD.

  METHOD plain_text_unchanged.
    " string with no special characters is returned as-is
    cl_abap_unit_assert=>assert_equals(
        exp = 'Hello World'
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( 'Hello World' ) ).
  ENDMETHOD.

  METHOD empty_input_unchanged.
    " empty string returns empty string
    cl_abap_unit_assert=>assert_initial(
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( `` ) ).
  ENDMETHOD.

  METHOD all_special_combined.
    " all five special characters are each encoded in a single pass
    cl_abap_unit_assert=>assert_equals(
        exp = |&amp;&lt;&gt;&quot;&#39;|
        act = zcl_pra_mf_bgmc_op_email_util=>escape_html( |&<>"'| ) ).
  ENDMETHOD.

ENDCLASS.



