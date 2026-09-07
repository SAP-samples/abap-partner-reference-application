CLASS zcl_pra_mf_bgmc_op_email_util DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF email_request_structure,
             visitor_name  TYPE zpra_mf_name,
             email_address TYPE c LENGTH 512,
             subject       TYPE c LENGTH 1024,
             message_body  TYPE c LENGTH 1000,
           END OF email_request_structure.

    INTERFACES if_bgmc_op_single_tx_uncontr.

    METHODS constructor
      IMPORTING email_input_data TYPE email_request_structure.
    CLASS-METHODS escape_html
      IMPORTING raw           TYPE string
      RETURNING VALUE(result) TYPE string.

  PRIVATE SECTION.
    DATA email_request TYPE email_request_structure.
ENDCLASS.



CLASS ZCL_PRA_MF_BGMC_OP_EMAIL_UTIL IMPLEMENTATION.


  METHOD constructor.
    email_request = email_input_data.
  ENDMETHOD.


  METHOD if_bgmc_op_single_tx_uncontr~execute.
    TRY.
        DATA(mail_message) = cl_bcs_mail_message=>create_instance( ).

        " Sender – fixed no-reply address for all notification emails
        mail_message->set_sender( 'noreply+abapprasbs@sap.corp' ).

        " Subject – direct char assignment, no conversion needed
        mail_message->set_subject( email_request-subject ).

        " Recipient – direct char assignment, no conversion needed
        mail_message->add_recipient(
            iv_address = email_request-email_address ).

        " HTML body – build personalised content, attach via cl_bcs_mail_textpart
        DATA(html_body) = |<h2>Dear { email_request-visitor_name },</h2><p>{ email_request-message_body }</p>|.
        mail_message->set_main( cl_bcs_mail_textpart=>create_text_html( html_body ) ).
        " Send and capture delivery status
        TEST-SEAM send_mail.  "#EC CI_TEST_SEAM_USAGE
          DATA(status_monitor) = mail_message->send( ).
          status_monitor->get_email_status(
              IMPORTING
                es_mail_status         = DATA(mail_status)
                et_recipients_statuses = DATA(recipients_statuses) ).
        END-TEST-SEAM.

      CATCH cx_bcs_mail INTO DATA(mail_exception).
        " Re-raise as BGMC operation exception so the framework can log/retry
        RAISE EXCEPTION NEW cx_bgmc_operation(
            previous       = mail_exception
            textid         = cx_bgmc_operation=>t100_operation_failed
            retry_settings = VALUE #( delay_time = 5
                                      do_retry   = abap_true ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD escape_html.
    result = raw.
    REPLACE ALL OCCURRENCES OF '&'  IN result WITH '&amp;'.
    REPLACE ALL OCCURRENCES OF '<'  IN result WITH '&lt;'.
    REPLACE ALL OCCURRENCES OF '>'  IN result WITH '&gt;'.
    REPLACE ALL OCCURRENCES OF '"'  IN result WITH '&quot;'.
    REPLACE ALL OCCURRENCES OF '''' IN result WITH '&#39;'.
  ENDMETHOD.
ENDCLASS.
