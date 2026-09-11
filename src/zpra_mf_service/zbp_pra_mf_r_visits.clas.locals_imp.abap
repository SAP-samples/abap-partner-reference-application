" local test classes
CLASS ltcl_methods DEFINITION DEFERRED FOR TESTING.

CLASS lhc_ZPRA_MF_BP_R_Visits DEFINITION INHERITING FROM cl_abap_behavior_handler
FRIENDS ltcl_methods .

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Visits RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Visits RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR visits RESULT result.

    "Actions
    METHODS book FOR MODIFY
      IMPORTING keys FOR ACTION Visits~book RESULT result.
    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION Visits~cancel RESULT result.
    METHODS sendUpdate FOR MODIFY
      IMPORTING keys FOR ACTION Visits~sendUpdate RESULT result.

    "Determinations
    METHODS determineStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Visits~determineStatus.
    METHODS determineAvailableSeats FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Visits~determineAvailableSeats.

    "Validations
    METHODS validateVisitor FOR VALIDATE ON SAVE
      IMPORTING keys FOR Visits~validateVisitor.

ENDCLASS.

CLASS lhc_ZPRA_MF_BP_R_Visits IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY Visits
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
      RESULT DATA(visits)
      FAILED failed.

    result = VALUE #( FOR visit IN visits
                      ( %tky   = visit-%tky

                        %action-book = COND #( WHEN visit-%is_draft = if_abap_behv=>mk-on
                                               THEN COND #( WHEN visit-Status = zcl_pra_mf_enum_visit_status=>booked
                                                            THEN if_abap_behv=>fc-o-disabled
                                                            ELSE if_abap_behv=>fc-o-enabled )
                                               ELSE if_abap_behv=>fc-o-disabled )

                       %action-cancel = COND #( WHEN visit-%is_draft = if_abap_behv=>mk-on
                                                THEN COND #( WHEN visit-Status = zcl_pra_mf_enum_visit_status=>cancelled
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE if_abap_behv=>fc-o-enabled )
                                               ELSE if_abap_behv=>fc-o-disabled )

                       %delete       = COND #( WHEN ( visit-Status = zcl_pra_mf_enum_visit_status=>cancelled
                                                   OR visit-Status = zcl_pra_mf_enum_visit_status=>pending )
                                               THEN if_abap_behv=>fc-o-enabled
                                               ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD book.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
    ENTITY Visits
       FIELDS ( Status )
       WITH CORRESPONDING #( keys )
    RESULT DATA(visits).

    CHECK lines( visits ) > 0.

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY Visits
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR visit IN visits
                      ( %tky   = visit-%tky
                        Status = zcl_pra_mf_enum_visit_status=>booked ) ).

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
    ENTITY Visits
       FIELDS ( Status )
       WITH CORRESPONDING #( keys )
    RESULT DATA(visits_after_update).

    result = VALUE #( FOR updated_visit IN visits_after_update
                      ( %tky   = updated_visit-%tky
                        %param = updated_visit ) ).


  ENDMETHOD.

  METHOD cancel.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
   ENTITY Visits
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
   RESULT DATA(visits).

    CHECK lines( visits ) > 0.

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY Visits
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR visit IN visits
                      ( %tky   = visit-%tky
                        Status = zcl_pra_mf_enum_visit_status=>cancelled ) ).

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
    ENTITY Visits
       FIELDS ( Status )
       WITH CORRESPONDING #( keys )
    RESULT DATA(visits_after_update).

    result = VALUE #( FOR updated_visit IN visits_after_update
                      ( %tky   = updated_visit-%tky
                        %param = updated_visit ) ).

  ENDMETHOD.

  METHOD determineStatus.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY Visits
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
      RESULT DATA(visits).

    DELETE visits WHERE Status IS NOT INITIAL.

    CHECK lines( visits ) > 0.

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY Visits
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR visit IN visits
                      ( %tky   = visit-%tky
                        Status = zcl_pra_mf_enum_visit_status=>pending ) ).

  ENDMETHOD.

  METHOD determineAvailableSeats.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
        ENTITY Visits
           FIELDS ( ParentUuid Status )
           WITH CORRESPONDING #( keys )
        RESULT DATA(visits).

    DELETE visits WHERE Status = zcl_pra_mf_enum_visit_status=>pending.
    CHECK lines( visits ) > 0.

    SORT visits ASCENDING BY ParentUuid.
    DELETE ADJACENT DUPLICATES FROM visits COMPARING ParentUuid.

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY MusicFestival
        EXECUTE calculateFreeVisitorSeats
        FROM VALUE #( FOR visit IN visits
                      ( uuid      = visit-ParentUuid
                        %is_draft = visit-%is_draft ) ).
  ENDMETHOD.

  METHOD sendupdate.
   " 1. Check SMTP scenario is configured
    IF NEW zcl_pra_mf_com_util( )->zif_pra_mf_com_util~is_scenario_configured( 'SAP_COM_0548' ) = abap_false.
      INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                               textid      = zcm_pra_mf_messages=>scenario_not_configured
                               severity    = if_abap_behv_message=>severity-error
                               scenario_id = 'SAP_COM_0548' ) )
             INTO TABLE reported-visits.
      failed-visits = CORRESPONDING #( keys ).
      RETURN.
    ENDIF.

    " 2. Read selected Visit records
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits
         FIELDS ( Uuid VisitorUuid ParentUuid )
         WITH CORRESPONDING #( keys )
         RESULT DATA(visits)
         FAILED failed.

    " 3. Navigate all selected visits → their MusicFestivals
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits BY \_MusicFestival
         FIELDS ( Title Description EventDateTime VisitorsFeeAmount VisitorsFeeCurrency )
         WITH CORRESPONDING #( visits )
         RESULT DATA(mf)
         FAILED DATA(mf_failed).

    " 4. Format EventDateTime — CONVERT UTCLONG requires TYPE d/t variables + TIME ZONE clause
    DATA datetime_str TYPE string.
    DATA date         TYPE d.
    DATA time         TYPE t.

    " 5. Navigate Visit → Visitor to get Name + Email for each selected participant
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits BY \_Visitor
         FIELDS ( Name Email )
         WITH CORRESPONDING #( visits )
         RESULT DATA(visitors)
         FAILED DATA(visitors_failed).

    " 6. Build and queue one BGMC email process per participant
    TRY.
        DATA(bgmc_factory) = cl_bgmc_process_factory=>get_default( ).

        LOOP AT visits REFERENCE INTO DATA(visit_ref).

          DATA(visitor_ref) = REF #(
              visitors[ KEY entity %key-Uuid = visit_ref->VisitorUuid ] OPTIONAL ).

          " Skip participants with no email address
          IF visitor_ref IS INITIAL OR visitor_ref->Email IS INITIAL.
            CONTINUE.
          ENDIF.

        " Resolve the MusicFestival record for this specific visit
          DATA(mf_line) = VALUE #( mf[ KEY entity %key-Uuid = visit_ref->ParentUuid ] OPTIONAL ).

          " Format EventDateTime for this visit's festival
          CLEAR: datetime_str, date, time.
          IF mf_line-EventDateTime IS NOT INITIAL.
            CONVERT UTCLONG mf_line-EventDateTime
                    INTO DATE date
                         TIME time
                    TIME ZONE 'UTC'.
            datetime_str = |{ date DATE = ISO } { time TIME = ISO } (UTC)|.
          ENDIF.

          " condense() strips trailing CHAR field padding — prevents "Dear Yatin ,"
          DATA visitor_name TYPE string.
          DATA subject      TYPE string.
          DATA body         TYPE string.
          DATA email        TYPE string.

          visitor_name = condense( CONV string( visitor_ref->Name ) ).
          subject = |Booking Confirmation: { condense( CONV string( mf_line-Title ) ) }|.
          email        = condense( CONV string( visitor_ref->Email ) ).

          DATA(title_esc)    = zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( CONV string( mf_line-Title ) ) ).
          DATA(desc_esc)     = zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( CONV string( mf_line-Description ) ) ).
          DATA(fee_esc)      = zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( CONV string( mf_line-VisitorsFeeAmount ) ) ).
          DATA(currency_esc) = zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( CONV string( mf_line-VisitorsFeeCurrency ) ) ).

          body = |Your participation in the following event has been confirmed. We look forward to welcoming you!<br><br>| &
                 |<table style="border-collapse:collapse;font-family:Arial,sans-serif;">| &
                 |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Event</td>| &
                 |<td style="padding:4px 0;">{ title_esc }</td></tr>| &
                 |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Theme</td>| &
                 |<td style="padding:4px 0;">{ desc_esc }</td></tr>| &
                 |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Date</td>| &
                 |<td style="padding:4px 0;">{ datetime_str }</td></tr>| &
                 |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Entry Fee</td>| &
                 |<td style="padding:4px 0;">{ fee_esc } { currency_esc }</td></tr>| &
                 |</table><br>| &
                 |<p style="font-family:Arial,sans-serif;font-size:12px;color:#555;">| &
                 |Please keep this email as your registration confirmation. For queries, contact the event organiser.</p>|.

          DATA(email_op) = NEW zcl_pra_mf_bgmc_op_email_util(
              VALUE zcl_pra_mf_bgmc_op_email_util=>email_request_structure(
                  visitor_name  = visitor_ref->Name
                  email_address = email
                  subject       = subject
                  message_body  = body ) ).

          DATA(bgmc_process) = bgmc_factory->create(
              )->set_name( 'SEND_UPDATE_EMAIL'
              )->set_operation_tx_uncontrolled( email_op ).

          APPEND bgmc_process TO zbp_pra_mf_r_musicfestival=>bgmc_email_processes.

        ENDLOOP.

      CATCH cx_bgmc INTO DATA(bgmc_exc).
        INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                                 textid         = zcm_pra_mf_messages=>error_bgpf_process_creation
                                 severity       = if_abap_behv_message=>severity-error
                                 exception_text = bgmc_exc->get_longtext( ) ) )
               INTO TABLE reported-visits.
        RETURN.
    ENDTRY.

    " 7. Return updated Visit records so Fiori Elements refreshes table rows
    result = VALUE #( FOR vis IN visits
                      ( %cid_ref = VALUE #( keys[ KEY entity %key = vis-%key ]-%cid_ref OPTIONAL )
                        %key     = vis-%key
                        %param   = vis ) ).
  ENDMETHOD.

  METHOD validateVisitor.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY Visits
         FIELDS ( VisitorUuid ParentUuid )
         WITH CORRESPONDING #( keys )
         RESULT DATA(visits).

    IF visits IS NOT INITIAL.
      READ ENTITIES OF ZPRA_MF_R_Visitor
           ENTITY Visitor
           FIELDS ( Uuid )
           WITH CORRESPONDING #( visits MAPPING Uuid = VisitorUuid EXCEPT * )
           RESULT DATA(existing_visitors).
    ENDIF.

    LOOP AT visits REFERENCE INTO DATA(visit).

      INSERT VALUE #( %tky        = visit->%tky
                      %state_area = zcm_pra_mf_messages=>state_area-validate_visit ) INTO TABLE reported-visits.

      IF NOT line_exists( existing_visitors[ KEY entity COMPONENTS Uuid = visit->VisitorUuid ] ).
        INSERT VALUE #( %tky = visit->%tky ) INTO TABLE failed-visits.
        INSERT VALUE #( %tky                 = visit->%tky
                        %state_area          = zcm_pra_mf_messages=>state_area-validate_visit
                        %path-MusicFestival-Uuid = visit->ParentUuid
                        %path-MusicFestival-%is_draft = visit->%is_draft
                        %msg                 = NEW zcm_pra_mf_messages(
                                                       textid   = zcm_pra_mf_messages=>visitor_invalid
                                                       severity = if_abap_behv_message=>severity-error ) ) INTO TABLE reported-visits.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
