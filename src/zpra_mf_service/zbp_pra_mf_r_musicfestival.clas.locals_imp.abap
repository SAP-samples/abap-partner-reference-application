" local test classes
CLASS ltc_validation_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltc_action_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltcl_determination_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltc_authorization_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltc_saver_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltc_email_methods DEFINITION DEFERRED FOR TESTING.
CLASS lhc_zpra_mf_r_musicfestival DEFINITION DEFERRED.
CLASS zbp_pra_mf_r_musicfestival DEFINITION LOCAL FRIENDS lhc_zpra_mf_r_musicfestival.

CLASS lhc_zpra_mf_r_musicfestival DEFINITION
  INHERITING FROM cl_abap_behavior_handler
  FRIENDS ltc_validation_methods
          ltc_action_methods
          ltcl_determination_methods
          ltc_authorization_methods.

  PRIVATE SECTION.
    DATA ai_service TYPE REF TO zif_pra_mf_gen_ai_util.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
      REQUEST requested_authorizations FOR MusicFestival
      RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR MusicFestival RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR MusicFestival RESULT result.

    ""Default
    METHODS GetDefaultsForCreate FOR READ
      IMPORTING keys FOR FUNCTION MusicFestival~GetDefaultsForCreate RESULT result.

    "Pre Check
    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE MusicFestival.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE MusicFestival.

    " Validations
    METHODS validateMandatoryValue FOR VALIDATE ON SAVE
      IMPORTING keys FOR MusicFestival~validateMandatoryValue.
    METHODS validateMaxVisitors FOR VALIDATE ON SAVE
      IMPORTING keys FOR MusicFestival~validateMaxVisitors.
    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR MusicFestival~validateDate.
    METHODS validateCustomFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR MusicFestival~validateCustomFields.

    " Determinations
    METHODS determineStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MusicFestival~determineStatus.
    METHODS determineAvailableSeats FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MusicFestival~determineAvailableSeats.
    METHODS determineID FOR DETERMINE ON SAVE
      IMPORTING keys FOR MusicFestival~determineID.

    " Actions
    METHODS calculateFreeVisitorSeats FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~calculateFreeVisitorSeats.
    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~cancel RESULT result.
    METHODS publish FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~publish RESULT result.
    METHODS createproject FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~CrProj RESULT result.
    METHODS generateSampleData FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~generateSampleData.
    METHODS createWithAI FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~createWithAI.
    METHODS printGuestList FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~printGuestList RESULT result.

    " Class Methods not linked to BO
    METHODS getAIService
      RETURNING VALUE(result) TYPE REF TO zif_pra_mf_gen_ai_util.

ENDCLASS.


CLASS lhc_zpra_mf_r_musicfestival IMPLEMENTATION.
  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      " check create authorization
      AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO' ID 'ACTVT' FIELD '01'.
      result-%create = COND #( WHEN sy-subrc = 0
                               THEN if_abap_behv=>auth-allowed
                               ELSE if_abap_behv=>auth-unauthorized ).
    ENDIF.

    IF requested_authorizations-%update = if_abap_behv=>mk-on.
      " check update authorization
      AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO' ID 'ACTVT' FIELD '02'.
      result-%update = COND #( WHEN sy-subrc = 0
                               THEN if_abap_behv=>auth-allowed
                               ELSE if_abap_behv=>auth-unauthorized ).
    ENDIF.

    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      " check delete authorization
      AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO' ID 'ACTVT' FIELD '06'.
      result-%delete = COND #( WHEN sy-subrc = 0
                               THEN if_abap_behv=>auth-allowed
                               ELSE if_abap_behv=>auth-unauthorized ).
    ENDIF.
  ENDMETHOD.

  METHOD get_instance_authorizations.
    DATA update_requested TYPE abap_bool.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Uuid ) WITH CORRESPONDING #( keys )
         RESULT DATA(events)
         FAILED failed.

    IF events IS INITIAL.
      RETURN.
    ENDIF.

    update_requested = COND #( WHEN requested_authorizations-%update         = if_abap_behv=>mk-on
                                 OR requested_authorizations-%delete         = if_abap_behv=>mk-on
                                 OR requested_authorizations-%action-publish = if_abap_behv=>mk-on
                               THEN abap_true
                               ELSE abap_false ).

    LOOP AT events ASSIGNING FIELD-SYMBOL(<lfs_events>).
      IF update_requested = abap_false.
        CONTINUE.
      ENDIF.

      " check authorization
      AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO'
                      ID 'ACTVT' FIELD '02'.
      IF sy-subrc <> 0.
        APPEND VALUE #( %tky                   = <lfs_events>-%tky
                        %update                = if_abap_behv=>auth-unauthorized
                        %delete                = if_abap_behv=>auth-unauthorized
                        %action-edit           = if_abap_behv=>auth-unauthorized
                        %action-publish        = if_abap_behv=>auth-unauthorized
                        %action-crproj         = if_abap_behv=>auth-unauthorized
                        %action-printguestlist = if_abap_behv=>auth-unauthorized ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    DATA music_festivals TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival.

    " Logic to enable create button only when status is Published
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Status project_id is_project_created is_project_crea_trig )
         WITH CORRESPONDING #( keys )
         RESULT music_festivals
         FAILED DATA(read_failed).

    DATA(music_festival) = VALUE #( music_festivals[ 1 ] OPTIONAL ).

    IF music_festival-project_id IS NOT INITIAL.
      SELECT SINGLE is_project_created,
                    is_project_crea_trig
      FROM zpra_mf_a_mf
      WHERE project_id = @music_festival-project_id
      INTO @DATA(active_music_fest).
      IF sy-subrc EQ 0.
        music_festival-is_project_created = active_music_fest-is_project_created.
        music_festival-is_project_crea_trig = active_music_fest-is_project_crea_trig.
      ENDIF.
    ENDIF.

    result = VALUE #( FOR event IN music_festivals
                      ( %tky                             = event-%tky
                        %features-%assoc-_Visits         = COND #(
                                  WHEN event-Status = zcl_pra_mf_enum_mf_status=>published
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled )

                        %features-%action-publish        = COND #(
                                 WHEN event-%is_draft  = if_abap_behv=>mk-off
                                  AND event-Status    <> zcl_pra_mf_enum_mf_status=>published
                                  AND event-Status    <> zcl_pra_mf_enum_mf_status=>fully_booked
                                 THEN if_abap_behv=>fc-o-enabled
                                 ELSE if_abap_behv=>fc-o-disabled )

                        %features-%delete                = COND #(
                                         WHEN event-Status = zcl_pra_mf_enum_mf_status=>published
                                           OR event-Status = zcl_pra_mf_enum_mf_status=>fully_booked
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled )

                        %features-%action-cancel         = COND #(
                                  WHEN event-%is_draft = if_abap_behv=>mk-off
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled )

                        %features-%action-CrProj         = COND #(
                                  WHEN event-Status = zcl_pra_mf_enum_mf_status=>published
                                   AND ( music_festival-is_project_created IS INITIAL
                                   AND music_festival-is_project_crea_trig IS INITIAL )
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled )

                        %features-%action-printGuestList = COND #(
                          WHEN event-%is_draft = if_abap_behv=>mk-off
                          THEN if_abap_behv=>fc-o-enabled
                          ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD GetDefaultsForCreate.
    result = VALUE #( FOR key IN keys (
                      %cid                       = key-%cid
                      %param-VisitorsFeeCurrency = 'INR'
                      ) ).
  ENDMETHOD.

  METHOD precheck_create.
    cl_pcf_field_validation=>create_instance(
      EXPORTING
        ir_failed   = REF #( failed )
        ir_reported = REF #( reported )
        is_entity   = VALUE #( name  = 'ZPRA_MF_R_MUSICFESTIVAL'
                               alias = 'MusicFestival' )
                      )->precheck_fields( REF #( entities ) ).
  ENDMETHOD.

  METHOD precheck_update.
    cl_pcf_field_validation=>create_instance(
      EXPORTING
        ir_failed   = REF #( failed )
        ir_reported = REF #( reported )
        is_entity   = VALUE #( name  = 'ZPRA_MF_R_MUSICFESTIVAL'
                               alias = 'MusicFestival' )
                      )->precheck_fields( REF #( entities ) ).
  ENDMETHOD.

  METHOD validateMandatoryValue.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Title EventDateTime MaxVisitorsNumber )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events REFERENCE INTO DATA(event).

      INSERT VALUE #( %tky        = event->%tky
                      %state_area = zcm_pra_mf_messages=>state_area-validate_event ) INTO TABLE reported-musicfestival.

      IF NOT (    event->Title             IS INITIAL
               OR event->EventDateTime     IS INITIAL
               OR event->MaxVisitorsNumber IS INITIAL ).
        CONTINUE.
      ENDIF.

      INSERT VALUE #( %tky = event->%tky ) INTO TABLE failed-musicfestival.
      INSERT VALUE #( %tky                       = event->%tky
                      %state_area                = zcm_pra_mf_messages=>state_area-validate_event
                      " Fill in all mandatory fields to proceed.
                      %msg                       = NEW zcm_pra_mf_messages(
                                                           textid   = zcm_pra_mf_messages=>event_mandatory_value_missing
                                                           severity = if_abap_behv_message=>severity-error )
                      %element-Title             = COND #( WHEN event->Title IS INITIAL
                                                           THEN if_abap_behv=>mk-on
                                                           ELSE if_abap_behv=>mk-off )
                      %element-EventDateTime     = COND #( WHEN event->EventDateTime IS INITIAL
                                                           THEN if_abap_behv=>mk-on
                                                           ELSE if_abap_behv=>mk-off )
                      %element-MaxVisitorsNumber = COND #( WHEN event->MaxVisitorsNumber IS INITIAL
                                                           THEN if_abap_behv=>mk-on
                                                           ELSE if_abap_behv=>mk-off ) ) INTO TABLE reported-musicfestival.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateMaxVisitors.
    DATA booked_visitors TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival\\Visits.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Uuid FreeVisitorSeats MaxVisitorsNumber )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events)
         ENTITY MusicFestival BY \_Visits
         FIELDS ( Uuid ParentUuid Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(event_visits).

    LOOP AT events REFERENCE INTO DATA(event).

      INSERT VALUE #( %tky        = event->%tky
                      %state_area = zcm_pra_mf_messages=>state_area-validate_visitors )
             INTO TABLE reported-musicfestival.

      IF event->MaxVisitorsNumber <= 0.
        INSERT VALUE #( %tky = event->%tky ) INTO TABLE failed-musicfestival.
        INSERT VALUE #( %tky                       = event->%tky
                        %state_area                = zcm_pra_mf_messages=>state_area-validate_visitors
                        " Maximum visitors must be greater than zero.
                        %msg                       = NEW zcm_pra_mf_messages(
                        textid   = zcm_pra_mf_messages=>max_visitor_zero_negative
                        severity = if_abap_behv_message=>severity-error )
                        %element-MaxVisitorsNumber = if_abap_behv=>mk-on )
               INTO TABLE reported-musicfestival.
        CONTINUE.
      ENDIF.

      booked_visitors = VALUE #( FOR visit IN event_visits
                                 WHERE ( ParentUuid = event->uuid
                                 AND     Status     = zcl_pra_mf_enum_visit_status=>booked )
                                       ( visit ) ).
      IF lines( booked_visitors ) > event->MaxVisitorsNumber.

        INSERT VALUE #( %tky = event->%tky ) INTO TABLE failed-musicfestival.
        INSERT VALUE #(
            %tky                       = event->%tky
            %state_area                = zcm_pra_mf_messages=>state_area-validate_visitors
            " Maximum visitors must be equal to or greater than booked visitors.
            %msg                       = NEW zcm_pra_mf_messages(
            textid   = zcm_pra_mf_messages=>max_visitors_less_than_booked
            severity = if_abap_behv_message=>severity-error )
            %element-MaxVisitorsNumber = if_abap_behv=>mk-on ) INTO TABLE reported-musicfestival.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateDate.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( EventDateTime )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events REFERENCE INTO DATA(event).

      INSERT VALUE #( %tky        = event->%tky
                      %state_area = zcm_pra_mf_messages=>state_area-validate_date ) INTO TABLE reported-musicfestival.

      IF event->EventDateTime IS NOT INITIAL AND event->EventDateTime < utclong_current( ).

        INSERT VALUE #( %tky = event->%tky ) INTO TABLE failed-musicfestival.
        INSERT VALUE #(
            %tky                   = event->%tky
            %state_area            = zcm_pra_mf_messages=>state_area-validate_date
            " Event date and time must be in the future.
            %msg                   = NEW zcm_pra_mf_messages( textid   = zcm_pra_mf_messages=>event_datetime_invalid
                                                              severity = if_abap_behv_message=>severity-error )
            %element-EventDateTime = if_abap_behv=>mk-on ) INTO TABLE reported-musicfestival.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCustomFields.
    cl_pcf_field_validation=>create_instance(
      EXPORTING
        ir_failed   = REF #( failed )
        ir_reported = REF #( reported )
        is_entity   = VALUE #( name  = 'ZPRA_MF_R_MUSICFESTIVAL'
                               alias = 'MusicFestival' )
                      )->validate_fields( REF #( keys ) ).
  ENDMETHOD.

  METHOD determineStatus.
    DATA booked_visitors TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival\\Visits.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Status MaxVisitorsNumber FreeVisitorSeats )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events)
         ENTITY MusicFestival BY \_Visits
         FIELDS ( ParentUuid Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(event_visits).

    LOOP AT events REFERENCE INTO DATA(event).

      booked_visitors = VALUE #( FOR visit IN event_visits
                                 WHERE ( ParentUuid = event->uuid
                                 AND     Status     = zcl_pra_mf_enum_visit_status=>booked )
                                       ( visit ) ).

      event->Status = COND #( WHEN event->Status IS INITIAL THEN
                                zcl_pra_mf_enum_mf_status=>in_preparation
                              WHEN event->Status = zcl_pra_mf_enum_mf_status=>fully_booked AND event->MaxVisitorsNumber <> lines(
                                  booked_visitors ) THEN
                                zcl_pra_mf_enum_mf_status=>published
                              WHEN event->MaxVisitorsNumber > 0 AND event->MaxVisitorsNumber = lines( booked_visitors ) THEN
                                zcl_pra_mf_enum_mf_status=>fully_booked
                              ELSE
                                event->Status ).
    ENDLOOP.

    IF lines( events ) <= 0.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
           ENTITY MusicFestival
           UPDATE FIELDS ( Status )
           WITH CORRESPONDING #( events ).
  ENDMETHOD.

  METHOD determineAvailableSeats.
    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
           ENTITY MusicFestival
           EXECUTE calculateFreeVisitorSeats
           FROM CORRESPONDING #( keys ).
  ENDMETHOD.

  METHOD determineID.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
        ENTITY MusicFestival
          FIELDS ( id )
          WITH CORRESPONDING #( keys )
        RESULT DATA(music_festivals).

    DELETE music_festivals WHERE id IS NOT INITIAL.
    CHECK music_festivals IS NOT INITIAL.

    SELECT SINGLE FROM zpra_mf_a_mf FIELDS MAX( id ) INTO @DATA(max_music_festival_id).

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY MusicFestival
        UPDATE FIELDS ( id )
        WITH VALUE #( FOR music_festival IN music_festivals INDEX INTO idx
                      ( %tky = music_festival-%tky
                        id   = max_music_festival_id + idx ) ).
  ENDMETHOD.


  METHOD calculateFreeVisitorSeats.
    DATA booked_visitors TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival\\Visits.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Uuid MaxVisitorsNumber FreeVisitorSeats )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events)
         ENTITY MusicFestival BY \_Visits
         FIELDS ( Uuid ParentUuid Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(event_visits).

    LOOP AT events REFERENCE INTO DATA(event).
      booked_visitors = VALUE #( FOR visit IN event_visits
                                 WHERE ( ParentUuid = event->uuid
                                 AND     Status     = zcl_pra_mf_enum_visit_status=>booked )
                                       ( visit ) ).

      event->FreeVisitorSeats = event->MaxVisitorsNumber - lines( booked_visitors ).
    ENDLOOP.

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
           ENTITY MusicFestival
           UPDATE FIELDS ( FreeVisitorSeats )
           WITH VALUE #( FOR updated_event IN events
                         ( %tky             = updated_event-%tky
                           FreeVisitorSeats = updated_event-FreeVisitorSeats ) ).
  ENDMETHOD.

  METHOD cancel.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
           ENTITY MusicFestival
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR event IN events
                         ( %tky   = event-%tky
                           Status = zcl_pra_mf_enum_mf_status=>cancelled ) ).

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(updated_events).

    result = VALUE #( FOR event IN updated_events
                      ( %tky   = event-%tky
                        %param = event ) ).
  ENDMETHOD.

  METHOD publish.
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Uuid Status FreeVisitorSeats Title )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
           ENTITY MusicFestival
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR mf_event IN events
                         ( %tky   = mf_event-%tky
                           Status = COND #( WHEN mf_event-FreeVisitorSeats = 0
                                            THEN zcl_pra_mf_enum_mf_status=>fully_booked
                                            ELSE zcl_pra_mf_enum_mf_status=>published ) ) ).

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events_after_update).

    result = VALUE #( FOR event_updated IN events_after_update
                      ( %tky   = event_updated-%tky
                        %param = event_updated ) ).
  ENDMETHOD.

  METHOD createproject.
    DATA project_details TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.
    DATA create_project_details TYPE zif_pra_mf_ent_proj_integ=>create_project_result.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    IF events IS INITIAL.
      RETURN.
    ENDIF.

    DATA(event) = VALUE #( events[ 1 ] OPTIONAL ).

    INSERT VALUE #( %tky = event-%tky
                    %msg = NEW zcm_pra_mf_messages(
                    textid   = zcm_pra_mf_messages=>proj_creation_triggered
                    severity = if_abap_behv_message=>severity-success ) )
      INTO TABLE reported-musicfestival.

    DATA music_fest TYPE zpra_mf_a_mf.

    music_fest-project_id = |MF_{ to_upper( event-Title ) }|.

    music_fest-uuid       = event-Uuid.

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
           ENTITY MusicFestival
           UPDATE FIELDS ( project_id is_project_crea_trig )
           WITH VALUE #( FOR entity IN events
                         ( %tky                 = entity-%tky
                           project_id           = music_fest-project_id
                           is_project_crea_trig = abap_true ) ).

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
         ENTITY MusicFestival
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(updated_entities).

    result = VALUE #( FOR event_updated IN updated_entities
                      ( %tky   = event_updated-%tky
                        %param = event_updated ) ).
  ENDMETHOD.

  METHOD generateSampleData.
    DATA create_visitors           TYPE TABLE FOR CREATE ZPRA_MF_R_Visitor.
    DATA create_music_fests        TYPE TABLE FOR CREATE ZPRA_MF_R_MusicFestival.
    DATA cba_music_fest_visits     TYPE TABLE FOR CREATE ZPRA_MF_R_MusicFestival\_Visits.
    DATA action_music_fest_publish TYPE TABLE FOR ACTION IMPORT ZPRA_MF_R_MusicFestival~publish.
    DATA action_visits_book        TYPE TABLE FOR ACTION IMPORT ZPRA_MF_R_MusicFestival\\Visits~book.

    " first create Visitors, so that they can be added in Music Fests as Visits
    create_visitors = VALUE #(
        ( %cid = `visitor01` Name = `Kenji Tanaka`     Email = `kenji.tanaka@pra.ondemand.com` )
        ( %cid = `visitor02` Name = `Suresh Kumar`     Email = `Suresh Kumar` )
        ( %cid = `visitor03` Name = `Jamal Adebayo`    Email = `jamal.adebayo@pra.ondemand.com` )
        ( %cid = `visitor04` Name = `Shreya Reddy`     Email = `shreya.reddy@pra.ondemand.com` )
        ( %cid = `visitor05` Name = `Miguel Rodriguez` Email = `miguel.rodriguez@pra.ondemand.com` )
        ( %cid = `visitor06` Name = `Naomi Chen`       Email = `naomi.chen@pra.ondemand.com` )
        ( %cid = `visitor07` Name = `Sofia Rossi`      Email = `sofia.rossi@pra.ondemand.com` )
        ( %cid = `visitor08` Name = `Liam Johnson`     Email = `liam.johnson@pra.ondemand.com` )
        ( %cid = `visitor09` Name = `Emma Brown`       Email = `emma.brown@pra.ondemand.com` )
        ( %cid = `visitor10` Name = `Noah Davis`       Email = `noah.davis@pra.ondemand.com` )
        ( %cid = `visitor11` Name = `Lukas Schneider`  Email = `lukas.schneider@pra.ondemand.com` ) ) ##NO_TEXT.
    MODIFY ENTITY ZPRA_MF_R_Visitor
           CREATE
           FIELDS ( Name Email )
           WITH create_visitors
           MAPPED   DATA(visitors_mapping)
           FAILED   DATA(visitors_failed)
           REPORTED DATA(visitors_reported).

    " create Music Festivals and Visits using (CreateByAssociation), Publish selected Music Fests, & Book Visits
    create_music_fests = VALUE #(
        VisitorsFeeAmount   = `99`
        VisitorsFeeCurrency = `USD`
        EventDateTime       = utclong_add( val               = utclong_current( )
                                           days              = 30 )
        (                                  %cid              = `mf01`
                                           Title             = `Tango Tales Buenos Aires`
                                           Description       = `Experience the passionate and intricate world of Argentine Tango.`
                                           MaxVisitorsNumber = `25` )
        (                                  %cid              = `mf02`
                                           Title             = `Sakura Spring Kyoto`
                                           Description       = `Celebrate the ephemeral beauty of cherry blossoms in ancient Kyoto.`
                                           MaxVisitorsNumber = `5` )
        (                                  %cid              = `mf03`
                                           Title             = `Mediterranean Melodies Athens`
                                           Description       = `Enjoy the soulful sounds and rhythms of the Mediterranean coast.`
                                           MaxVisitorsNumber = `50` )
        (                                  %cid              = `mf04`
                                           Title             = `Stage of Words New York`
                                           Description       = `Welcome to a stage in New York where words reign supreme`
                                           MaxVisitorsNumber = `10` )
        (                                  %cid              = `mf05`
                                           Title             = `Rhythm of Rajasthan`
                                           Description       = `Immerse yourself in the vibrant folk music and dance of Rajasthan.`
                                           MaxVisitorsNumber = `20` ) ) ##NO_TEXT.

    cba_music_fest_visits = VALUE #(
        ( %cid_ref = `mf02`
          %target  = VALUE #( ( %cid        = `mf02_1` VisitorUuid = visitors_mapping-visitor[ 2 ]-uuid )
                              ( %cid        = `mf02_2` VisitorUuid = visitors_mapping-visitor[ 3 ]-uuid )
                              ( %cid        = `mf02_3` VisitorUuid = visitors_mapping-visitor[ 4 ]-uuid )
                              ( %cid        = `mf02_4` VisitorUuid = visitors_mapping-visitor[ 5 ]-uuid )
                              ( %cid        = `mf02_5` VisitorUuid = visitors_mapping-visitor[ 6 ]-uuid ) ) )
        ( %cid_ref = `mf03`
          %target  = VALUE #( ( %cid        = `mf03_1`
                                VisitorUuid = visitors_mapping-visitor[ 1 ]-uuid ) ) )
        ( %cid_ref = `mf04`
          %target  = VALUE #( ( %cid        = `mf04_1` VisitorUuid = visitors_mapping-visitor[ 7 ]-uuid )
                              ( %cid        = `mf04_2` VisitorUuid = visitors_mapping-visitor[ 8 ]-uuid ) ) ) ).
    action_music_fest_publish = VALUE #( ( %cid_ref = `mf02` )
                                         ( %cid_ref = `mf03` )
                                         ( %cid_ref = `mf04` ) ).
    action_visits_book = VALUE #( ( %cid_ref = `mf02_1` )
                                  ( %cid_ref = `mf02_2` )
                                  ( %cid_ref = `mf02_3` )
                                  ( %cid_ref = `mf02_4` )
                                  ( %cid_ref = `mf02_5` )
                                  ( %cid_ref = `mf03_1` )
                                  ( %cid_ref = `mf04_1` )
                                  ( %cid_ref = `mf04_2` ) ).

    MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
           ENTITY MusicFestival
           CREATE
           FIELDS ( Title Description EventDateTime MaxVisitorsNumber VisitorsFeeAmount VisitorsFeeCurrency )
           WITH create_music_fests
           EXECUTE publish FROM action_music_fest_publish
           CREATE BY \_Visits
           FIELDS ( VisitorUuid )
           WITH cba_music_fest_visits
           ENTITY Visits
           EXECUTE book FROM action_visits_book
           MAPPED mapped
           FAILED failed
           REPORTED reported.
  ENDMETHOD.

  METHOD createWithAI.
    TYPES: BEGIN OF mf_create_data_structure,
             cid          TYPE abp_behv_cid,
             is_draft     TYPE abp_behv_flag,
             llm_response TYPE zcl_pra_mf_gen_ai_util=>zif_pra_mf_gen_ai_util~llm_response_structure,
           END OF mf_create_data_structure.

    DATA mf_create_data TYPE TABLE OF mf_create_data_structure.

    IF NEW zcl_pra_mf_com_util( )->zif_pra_mf_com_util~is_scenario_configured( 'SAP_COM_0A69' ) = abap_false.
      " No active communication arrangement for scenario SCENARIO_ID found
      INSERT VALUE #( %msg = NEW zcm_pra_mf_messages( textid      = zcm_pra_mf_messages=>scenario_not_configured
                                                      severity    = if_abap_behv_message=>severity-error
                                                      scenario_id = 'SAP_COM_0A69' ) ) INTO TABLE reported-musicfestival.
      failed-musicfestival = CORRESPONDING #( keys ).
      RETURN.
    ENDIF.

    LOOP AT keys REFERENCE INTO DATA(key).

      TRY.
          DATA(llm_response) = getAIService( )->generate_music_festival_data( language        = key->%param-language
                                                                              tags            = key->%param-tags
                                                                              rhyme_indicator = key->%param-rhyme ).
          llm_response-description = |{ llm_response-description } \n\nDisclaimer: This content is generated by AI|.

          APPEND VALUE #( cid          = key->%cid
                          is_draft     = key->%param-%is_draft
                          llm_response = llm_response ) TO mf_create_data.

        CATCH cx_root INTO DATA(exception).
          DATA(exception_text) = exception->get_longtext( ).
          " Musical event creation with AI failed. Please try again. Error: EXCEPTION_TEXT
          INSERT VALUE #( %msg = NEW zcm_pra_mf_messages( textid         = zcm_pra_mf_messages=>create_with_ai_failed
                                                          severity       = if_abap_behv_message=>severity-error
                                                          exception_text = exception_text ) ) INTO TABLE reported-musicfestival.
          INSERT VALUE #( %cid = key->%cid ) INTO TABLE failed-musicfestival.
      ENDTRY.

    ENDLOOP.

    MODIFY ENTITIES OF zpra_mf_r_musicfestival IN LOCAL MODE
           ENTITY MusicFestival
           CREATE
           FIELDS ( Title Description )
           WITH VALUE #( FOR line_item IN mf_create_data
                         ( %cid        = line_item-cid
                           %is_draft   = line_item-is_draft
                           Title       = line_item-llm_response-title
                           Description = line_item-llm_response-description ) )
           MAPPED mapped.
  ENDMETHOD.

  METHOD getAIService.
    IF ai_service IS INITIAL.
      ai_service = zcl_pra_mf_gen_ai_util=>get_instance( ).
    ENDIF.
    result = ai_service.
  ENDMETHOD.

  METHOD printguestlist.
    CONSTANTS form_name          TYPE string VALUE 'ZPRA_MF_PDF_FORM_MF'.
    CONSTANTS service_definition TYPE string VALUE 'ZPRA_MF_MUSICFESTIVAL'.

    IF NEW zcl_pra_mf_com_util( )->zif_pra_mf_com_util~is_scenario_configured( 'SAP_COM_0466' ) = abap_false.
      " No active communication arrangement for scenario SCENARIO_ID found
      INSERT VALUE #( %msg = NEW zcm_pra_mf_messages( textid      = zcm_pra_mf_messages=>scenario_not_configured
                                                      severity    = if_abap_behv_message=>severity-error
                                                      scenario_id = 'SAP_COM_0466' ) ) INTO TABLE reported-musicfestival.
      failed-musicfestival = CORRESPONDING #( keys ).
      RETURN.
    ENDIF.

    TRY.
        DATA(bgmc_process_factory) = cl_bgmc_process_factory=>get_default( ).
        DATA bgmc_print_util TYPE REF TO zcl_pra_mf_bgmc_op_print_util.
        DATA bgmc_process    TYPE REF TO if_bgmc_process.

        LOOP AT keys REFERENCE INTO DATA(key).
          bgmc_print_util = NEW zcl_pra_mf_bgmc_op_print_util( VALUE zcl_pra_mf_bgmc_op_print_util=>print_request_structure(
                                                                         form_name   = form_name
                                                                         print_queue = key->%param-print_queue
                                                                         uuid        = key->Uuid
                                                                         fdp_srvd    = service_definition ) ).

          bgmc_process = bgmc_process_factory->create( )->set_name( 'PRINT_MUSICAL_FESTIVAL' )->set_operation_tx_uncontrolled(
                                                                                                 bgmc_print_util ).

          APPEND bgmc_process TO zbp_pra_mf_r_musicfestival=>bgmc_processes.

          APPEND VALUE #( %cid_ref    = key->%cid_ref
                          uuid        = key->Uuid
                          %param-Uuid = key->Uuid )
                 TO result.
        ENDLOOP.

      CATCH cx_bgmc INTO DATA(exception).
        " Error during background process creation. Error: EXCEPTION_TEXT
        INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                        textid         = zcm_pra_mf_messages=>error_bgpf_process_creation
                        severity       = if_abap_behv_message=>severity-error
                        exception_text = exception->get_longtext( ) ) )
               INTO TABLE reported-musicfestival.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zpra_mf_r_musicfestival DEFINITION DEFERRED.
CLASS zbp_pra_mf_r_musicfestival DEFINITION LOCAL FRIENDS lsc_zpra_mf_r_musicfestival.

CLASS lsc_zpra_mf_r_musicfestival DEFINITION INHERITING FROM cl_abap_behavior_saver FRIENDS ltc_saver_methods
                                                                                            ltc_email_methods.
  TYPES create_data_structure_mf    TYPE TABLE FOR CHANGE zpra_mf_r_musicfestival.
  TYPES create_data_structure_visit TYPE TABLE FOR CHANGE zpra_mf_r_visit.
  TYPES delete_data_visit_key       TYPE TABLE FOR KEY OF zpra_mf_r_visit.
  TYPES delete_data_mf_key          TYPE TABLE FOR KEY OF zpra_mf_r_musicfestival.
  TYPES reported_data_mf            TYPE TABLE FOR REPORTED LATE zpra_mf_r_musicfestival.
  TYPES reported_data_proj          TYPE RESPONSE FOR REPORTED LATE zpra_mf_r_musicfestival.

  CONSTANTS true_indicator  TYPE c LENGTH 1    VALUE 'X'.
  CONSTANTS control_changed TYPE abp_behv_flag VALUE '01'.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

  PRIVATE SECTION.
    METHODS raise_mf_created_event IMPORTING create_data_mf TYPE create_data_structure_mf.

    METHODS handle_mf_update_event IMPORTING create_data_visit TYPE create_data_structure_visit
                                             update_data_mf    TYPE create_data_structure_mf
                                             update_data_visit TYPE create_data_structure_visit
                                             delete_data_visit TYPE delete_data_visit_key.

    METHODS raise_mf_deleted_event       IMPORTING delete_data_mf    TYPE delete_data_mf_key.
    METHODS handle_visit_changes_event   IMPORTING update_data_visit TYPE create_data_structure_visit.
    METHODS raise_ent_proj_created_event IMPORTING update_data_mf TYPE create_data_structure_mf
                                         CHANGING  reported       TYPE reported_data_proj.

    METHODS read_artist_name IMPORTING visit_uuid    TYPE sysuuid_x16
                             RETURNING VALUE(result) TYPE zpra_mf_name.

    " ── Automated notification helpers ───────────────────────────────────────
    " Prio 1 – notify one specific visitor on Booked / Cancelled status change

    METHODS queue_visit_status_email
      IMPORTING
        visitor_name   TYPE string
        visitor_email  TYPE string
        mf_title       TYPE string
        mf_description TYPE string
        mf_eventdt     TYPE utclong
        new_status     TYPE zpra_mf_music_fest_status_code.


    " Prio 2 / 3 / 4 – notify all booked visitors of an event
    METHODS queue_booked_visitors_email
      IMPORTING
        mf_uuid            TYPE sysuuid_x16
        notification_text  TYPE string
        change_info        TYPE string
        new_event_datetime TYPE utclong OPTIONAL.

    " Orchestrates all email notifications triggered by a save cycle
    METHODS queue_event_emails
      IMPORTING
        update_data_mf    TYPE create_data_structure_mf
        update_data_visit TYPE create_data_structure_visit
        create_data_visit TYPE create_data_structure_visit
      CHANGING
        reported_mf       TYPE reported_data_mf.
ENDCLASS.


CLASS lsc_zpra_mf_r_musicfestival IMPLEMENTATION.
  METHOD save_modified.
    " Backgroud process for printing

    DATA : enterprise_project_assigned TYPE STRUCTURE FOR EVENT zpra_mf_r_musicfestival~EntProjectAssigned.

    LOOP AT zbp_pra_mf_r_musicfestival=>bgmc_processes INTO DATA(process).
      TRY.
          process->save_for_execution( ).
        CATCH cx_bgmc INTO DATA(exception).
          " Error during background process execution. Error: EXCEPTION_TEXT
          INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                          textid         = zcm_pra_mf_messages=>error_bgpf_process_execution
                          severity       = if_abap_behv_message=>severity-error
                          exception_text = exception->get_longtext( ) ) )
                 INTO TABLE reported-musicfestival.
      ENDTRY.
      DELETE zbp_pra_mf_r_musicfestival=>bgmc_processes.
    ENDLOOP.

    queue_event_emails(
      EXPORTING
        update_data_mf    = update-musicfestival
        update_data_visit = update-visits
        create_data_visit = create-visits
      CHANGING
        reported_mf       = reported-musicfestival ).

    IF create-musicfestival IS NOT INITIAL.
      raise_mf_created_event( create-musicfestival ).
    ENDIF.

    IF update-musicfestival IS NOT INITIAL.

      DATA(updated_mf) = update-musicfestival[ 1 ].

      enterprise_project_assigned-Uuid = updated_mf-Uuid.
      enterprise_project_assigned-Title = updated_mf-Title.
      enterprise_project_assigned-EventDateTime = updated_mf-EventDateTime.
      enterprise_project_assigned-Project_Id = updated_mf-project_id.

      IF update-musicfestival[ 1 ]-is_project_created EQ abap_false AND
         update-musicfestival[ 1 ]-%control-is_project_created IS NOT INITIAL.
        RAISE ENTITY EVENT zpra_mf_r_musicfestival~ProjectCreated
          FROM VALUE #( (
                        %key = CORRESPONDING #( enterprise_project_assigned )
                      ) ).
      ELSEIF update-musicfestival[ 1 ]-is_project_created EQ abap_true.
        RAISE ENTITY EVENT zpra_mf_r_musicfestival~ProjectCreated
          FROM VALUE #( (
                        %key = CORRESPONDING #( enterprise_project_assigned )
                      ) ).

        RAISE ENTITY EVENT zpra_mf_r_musicfestival~EntProjectAssigned
          FROM VALUE #( (
                        %key   = CORRESPONDING #( enterprise_project_assigned )
                        %param = CORRESPONDING #( enterprise_project_assigned )
                      ) ).

      ENDIF.


      handle_mf_update_event( create_data_visit = create-visits
                              update_data_mf    = update-musicfestival
                              update_data_visit = update-visits
                              delete_data_visit = delete-visits ).

      raise_ent_proj_created_event( EXPORTING update_data_mf = update-musicfestival
                                    CHANGING  reported       = reported ).

    ENDIF.

    IF delete-musicfestival IS NOT INITIAL.
      raise_mf_deleted_event( delete-musicfestival ).
    ENDIF.

    IF update-visits IS NOT INITIAL.
      handle_visit_changes_event( update-visits ).
    ENDIF.
  ENDMETHOD.

  METHOD raise_mf_created_event.
    DATA music_event_created TYPE STRUCTURE FOR EVENT zpra_mf_r_musicfestival~MusicEventCreated.

    music_event_created-Uuid          = create_data_mf[ 1 ]-Uuid.
    music_event_created-Title         = create_data_mf[ 1 ]-Title.
    music_event_created-EventDateTime = create_data_mf[ 1 ]-EventDateTime.
    music_event_created-Status        = create_data_mf[ 1 ]-Status.

    RAISE ENTITY EVENT zpra_mf_r_musicfestival~MusicEventCreated
          FROM VALUE #( ( %key   = CORRESPONDING #( music_event_created )
                          %param = CORRESPONDING #( music_event_created ) ) ).
  ENDMETHOD.

  METHOD handle_mf_update_event.
    DATA music_event_updated TYPE STRUCTURE FOR EVENT zpra_mf_r_musicfestival~MusicEventUpdated.

    DATA(mf_updated) = update_data_mf[ 1 ].

    IF line_exists( update_data_visit[ %control-ArtistIndicator = control_changed ] ).
      TEST-SEAM artist_updated.      "#EC TEST_SEAM_USAGE for TEST-SEAM
        DATA(visit_uuid_updated) = VALUE #( update_data_visit[ ArtistIndicator = true_indicator ]-Uuid OPTIONAL ).
        IF visit_uuid_updated IS NOT INITIAL.
          music_event_updated-ArtistName = read_artist_name( visit_uuid_updated ).
        ENDIF.

        SELECT SINGLE visitor~name
          FROM zpra_mf_r_visit AS visit
                 INNER JOIN
                   ZPRA_mf_R_Visitor AS visitor ON visit~VisitorUuid = visitor~Uuid
          WHERE visit~ParentUuid = @mf_updated-Uuid
            AND ArtistIndicator  = @true_indicator
          INTO @DATA(artist_name_old)
          PRIVILEGED ACCESS.
        IF sy-subrc IS INITIAL.
          music_event_updated-__before-ArtistName = artist_name_old.
        ENDIF.
      END-TEST-SEAM.
    ENDIF.

    IF line_exists( create_data_visit[ %control-ArtistIndicator = control_changed ] ).
      DATA(visit_uuid_created) = VALUE #( create_data_visit[ ArtistIndicator = true_indicator ]-Uuid OPTIONAL ).
      IF visit_uuid_created IS NOT INITIAL.
        music_event_updated-ArtistName = read_artist_name( visit_uuid_created ).
      ENDIF.
    ENDIF.

    IF delete_data_visit IS NOT INITIAL.
      DATA(visit_uuid_deleted) = delete_data_visit[ 1 ]-Uuid.

      SELECT SINGLE visitor~name
        FROM zpra_mf_r_visit AS visit
               INNER JOIN
                 zpra_mf_r_visitor AS visitor ON visitor~Uuid = visit~VisitorUuid
        WHERE visit~Uuid      = @visit_uuid_deleted
          AND ArtistIndicator = @true_indicator
        INTO @DATA(artist_name_deleted)
        PRIVILEGED ACCESS.
      IF sy-subrc IS INITIAL.
        music_event_updated-__before-ArtistName = artist_name_deleted.
      ENDIF.
    ENDIF.

    IF    mf_updated-%control-Title               IS NOT INITIAL
       OR mf_updated-%control-Status              IS NOT INITIAL
       OR mf_updated-%control-MaxVisitorsNumber   IS NOT INITIAL
       OR mf_updated-%control-FreeVisitorSeats    IS NOT INITIAL
       OR mf_updated-%control-VisitorsFeeAmount   IS NOT INITIAL
       OR mf_updated-%control-VisitorsFeeCurrency IS NOT INITIAL
       OR mf_updated-%control-EventDateTime       IS NOT INITIAL
       OR (    music_event_updated-ArtistName          IS NOT INITIAL
            OR music_event_updated-__before-ArtistName IS NOT INITIAL ).

      SELECT SINGLE FROM zpra_mf_r_musicfestival
        FIELDS Title, Status, MaxVisitorsNumber, FreeVisitorSeats, VisitorsFeeAmount, VisitorsFeeCurrency, EventDateTime
        WHERE Uuid = @mf_updated-Uuid
        INTO @DATA(mf_old)
        PRIVILEGED ACCESS.
      IF sy-subrc IS NOT INITIAL.
        CLEAR mf_old.
      ENDIF.

      IF     music_event_updated-ArtistName          IS INITIAL
         AND music_event_updated-__before-ArtistName IS INITIAL.
        READ ENTITIES OF zpra_mf_r_musicfestival IN LOCAL MODE
             ENTITY MusicFestival BY \_Visits
             FIELDS ( ArtistIndicator ) WITH VALUE #( ( %key-Uuid = update_data_mf[ 1 ]-Uuid ) )
             RESULT DATA(visitors).
        IF line_exists( visitors[ ArtistIndicator = true_indicator ] ).
          READ ENTITIES OF zpra_mf_r_musicfestival IN LOCAL MODE
               ENTITY Visits BY \_Visitor
               FIELDS ( Name ) WITH VALUE #( ( %key-Uuid = visitors[ ArtistIndicator = true_indicator ]-Uuid ) )
               RESULT DATA(artist)
               FAILED DATA(read_failed).
          IF read_failed IS INITIAL AND artist[ 1 ]-Name IS NOT INITIAL.
            music_event_updated-ArtistName = artist[ 1 ]-Name.
            music_event_updated-__before-ArtistName = artist[ 1 ]-Name.
          ENDIF.
        ENDIF.
      ENDIF.

      music_event_updated-uuid                = mf_updated-uuid.
      music_event_updated-Title               = COND #( WHEN mf_updated-%control-Title IS NOT INITIAL
                                                        THEN mf_updated-Title
                                                        ELSE mf_old-Title ).
      music_event_updated-Status              = COND #( WHEN mf_updated-%control-Status IS NOT INITIAL
                                                        THEN mf_updated-Status
                                                        ELSE mf_old-Status ).
      music_event_updated-MaxVisitorsNumber   = COND #( WHEN mf_updated-%control-MaxVisitorsNumber IS NOT INITIAL
                                                        THEN mf_updated-MaxVisitorsNumber
                                                        ELSE mf_old-MaxVisitorsNumber ).
      music_event_updated-FreeVisitorSeats    = COND #( WHEN mf_updated-%control-FreeVisitorSeats IS NOT INITIAL
                                                        THEN mf_updated-FreeVisitorSeats
                                                        ELSE mf_old-FreeVisitorSeats ).
      music_event_updated-VisitorsFeeAmount   = COND #( WHEN mf_updated-%control-VisitorsFeeAmount IS NOT INITIAL
                                                        THEN mf_updated-VisitorsFeeAmount
                                                        ELSE mf_old-VisitorsFeeAmount ).
      music_event_updated-VisitorsFeeCurrency = COND #( WHEN mf_updated-%control-VisitorsFeeCurrency IS NOT INITIAL
                                                        THEN mf_updated-VisitorsFeeCurrency
                                                        ELSE mf_old-VisitorsFeeCurrency ).
      music_event_updated-EventDateTime       = COND #( WHEN mf_updated-%control-EventDateTime IS NOT INITIAL
                                                        THEN mf_updated-EventDateTime
                                                        ELSE mf_old-EventDateTime ).

      music_event_updated-__before-Title               = mf_old-Title.
      music_event_updated-__before-Status              = mf_old-Status.
      music_event_updated-__before-MaxVisitorsNumber   = mf_old-MaxVisitorsNumber.
      music_event_updated-__before-FreeVisitorSeats    = mf_old-FreeVisitorSeats.
      music_event_updated-__before-VisitorsFeeAmount   = mf_old-VisitorsFeeAmount.
      music_event_updated-__before-VisitorsFeeCurrency = mf_old-VisitorsFeeCurrency.
      music_event_updated-__before-EventDateTime       = mf_old-EventDateTime.

      RAISE ENTITY EVENT zpra_mf_r_musicfestival~MusicEventUpdated
            FROM VALUE #( ( %key   = CORRESPONDING #( music_event_updated )
                            %param = CORRESPONDING #( music_event_updated ) ) ).
    ENDIF.
  ENDMETHOD.

  METHOD raise_mf_deleted_event.
    DATA music_event_deleted TYPE STRUCTURE FOR EVENT zpra_mf_r_musicfestival~MusicEventDeleted.

    DATA(mf_uuid_deleted) = delete_data_mf[ 1 ]-Uuid.

    SELECT SINGLE Title FROM zpra_mf_r_musicfestival
      WHERE Uuid = @mf_uuid_deleted
      INTO @DATA(mf_title_deleted)
      PRIVILEGED ACCESS.
    IF sy-subrc IS INITIAL.
      music_event_deleted-Uuid  = mf_uuid_deleted.
      music_event_deleted-Title = mf_title_deleted.
    ENDIF.

    RAISE ENTITY EVENT zpra_mf_r_musicfestival~MusicEventDeleted
          FROM VALUE #( ( %key   = CORRESPONDING #( music_event_deleted )
                          %param = CORRESPONDING #( music_event_deleted ) ) ).
  ENDMETHOD.

  METHOD handle_visit_changes_event.
    DATA visit_booked_event    TYPE STRUCTURE FOR EVENT zpra_mf_r_visit~VisitBooked.
    DATA visit_cancelled_event TYPE STRUCTURE FOR EVENT zpra_mf_r_visit~VisitCancelled.
    DATA visit_uuids           TYPE TABLE FOR READ IMPORT zpra_mf_r_visit\_Visitor.

    visit_uuids = CORRESPONDING #( update_data_visit ).

    TEST-SEAM read_artists.          "#EC TEST_SEAM_USAGE for TEST-SEAM
      READ ENTITIES OF zpra_mf_r_musicfestival IN LOCAL MODE
           ENTITY Visits BY \_Visitor
           FIELDS ( Uuid Name ) WITH visit_uuids
           RESULT DATA(visitor_names).
    END-TEST-SEAM.

    LOOP AT update_data_visit INTO DATA(visit).
      IF visit-%control-Status IS INITIAL.
        CONTINUE.
      ENDIF.

      IF visit-Status = zcl_pra_mf_enum_visit_status=>booked.

        visit_booked_event-ParentUuid  = visit-ParentUuid.
        visit_booked_event-Uuid        = visit-Uuid.
        visit_booked_event-VisitorUuid = visit-VisitorUuid.
        visit_booked_event-name        = VALUE #( visitor_names[ KEY entity COMPONENTS Uuid = visit-VisitorUuid ]-Name OPTIONAL ).

        RAISE ENTITY EVENT zpra_mf_r_visit~VisitBooked
              FROM VALUE #( ( %key   = CORRESPONDING #( visit )
                              %param = CORRESPONDING #( visit_booked_event ) ) ).
        CLEAR visit_booked_event.

      ELSEIF visit-Status = zcl_pra_mf_enum_visit_status=>cancelled.

        visit_cancelled_event-ParentUuid  = visit-ParentUuid.
        visit_cancelled_event-Uuid        = visit-Uuid.
        visit_cancelled_event-VisitorUuid = visit-VisitorUuid.
        visit_cancelled_event-name        = VALUE #( visitor_names[ KEY entity
                                                     COMPONENTS Uuid = visit-VisitorUuid ]-Name OPTIONAL ).

        RAISE ENTITY EVENT zpra_mf_r_visit~VisitCancelled
              FROM VALUE #( ( %key   = CORRESPONDING #( visit )
                              %param = CORRESPONDING #( visit_cancelled_event ) ) ).
        CLEAR visit_cancelled_event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD raise_ent_proj_created_event.
    DATA enterprise_project_assigned TYPE STRUCTURE FOR EVENT zpra_mf_r_musicfestival~EntProjectAssigned.
    DATA: ent_proj_in_bgpf TYPE REF TO zcl_pra_mf_ent_proj_bgpf,
          bgmc_process     TYPE REF TO if_bgmc_process_single_op,
          bgmc             TYPE REF TO cx_bgmc,
          project_details  TYPE zcl_pra_mf_scm_ent_proj=>tys_a_enterprise_project_type.

    DATA(mf_updated) = update_data_mf[ 1 ].

    IF mf_updated-%control-project_id IS NOT INITIAL.
      enterprise_project_assigned-Uuid          = mf_updated-Uuid.
      enterprise_project_assigned-Title         = mf_updated-Title.
      enterprise_project_assigned-EventDateTime = mf_updated-EventDateTime.
      enterprise_project_assigned-Project_Id    = mf_updated-project_id.

      project_details-project = enterprise_project_assigned-title.
*      project_details-project_description = mf_updated-%control-Description.
      project_details-project_description = mf_updated-Description.

      CONVERT UTCLONG
      enterprise_project_assigned-EventDateTime
      INTO DATE DATA(event_date)
      TIME DATA(event_time)
      TIME ZONE 'UTC'.

      project_details-project_start_date = event_date.
      project_details-project_end_date = event_date.
      project_details-project_uuid = mf_updated-Uuid.

      ent_proj_in_bgpf = zcl_pra_mf_ent_proj_bgpf=>create_object( ).
      ent_proj_in_bgpf->project_details_instance = project_details.

      TRY.
          bgmc_process = cl_bgmc_process_factory=>get_default( )->create( ).
          bgmc_process->set_operation( ent_proj_in_bgpf ).
        CATCH cx_bgmc INTO bgmc.
          INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                          textid         = zcm_pra_mf_messages=>error_bgpf_process_creation
                          severity       = if_abap_behv_message=>severity-error
                          exception_text = bgmc->get_longtext( ) ) )
                 INTO TABLE reported-musicfestival.
      ENDTRY.

      TRY.

          bgmc_process->save_for_execution( ).

        CATCH cx_bgmc INTO bgmc.
          INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                          textid         = zcm_pra_mf_messages=>error_bgpf_process_execution
                          severity       = if_abap_behv_message=>severity-error
                          exception_text = bgmc->get_longtext( ) ) )
                 INTO TABLE reported-musicfestival.
      ENDTRY.

*      RAISE ENTITY EVENT zpra_mf_r_musicfestival~EntProjectAssigned
*            FROM VALUE #( ( %key   = CORRESPONDING #( enterprise_project_assigned )
*                            %param = CORRESPONDING #( enterprise_project_assigned ) ) ).
    ENDIF.
  ENDMETHOD.

  METHOD read_artist_name.
    READ ENTITIES OF zpra_mf_r_musicfestival IN LOCAL MODE
         ENTITY Visits BY \_Visitor
         FIELDS ( Name )
         WITH VALUE #( ( %key-Uuid = visit_uuid ) )
         RESULT DATA(artist_new)
         FAILED DATA(read_failed).

    IF read_failed IS INITIAL AND artist_new[ 1 ]-name IS NOT INITIAL.
      result = artist_new[ 1 ]-name.
    ENDIF.
  ENDMETHOD.

  METHOD queue_event_emails.
    DATA status_visits TYPE create_data_structure_visit.
    LOOP AT update_data_visit INTO DATA(visit_upd).
      CHECK visit_upd-%control-Status IS NOT INITIAL.
      CHECK    visit_upd-Status = zcl_pra_mf_enum_visit_status=>booked
            OR visit_upd-Status = zcl_pra_mf_enum_visit_status=>cancelled.
      APPEND visit_upd TO status_visits.
    ENDLOOP.

    LOOP AT create_data_visit INTO DATA(visit_crt).
      CHECK visit_crt-%control-Status IS NOT INITIAL.
      CHECK    visit_crt-Status = zcl_pra_mf_enum_visit_status=>booked
            OR visit_crt-Status = zcl_pra_mf_enum_visit_status=>cancelled.
      APPEND visit_crt TO status_visits.
    ENDLOOP.

    IF status_visits IS NOT INITIAL.
      DATA visitor_uuids TYPE RANGE OF sysuuid_x16.
      DATA mf_uuids      TYPE RANGE OF sysuuid_x16.

      LOOP AT status_visits INTO DATA(sv).
        INSERT VALUE #( sign = 'I' option = 'EQ' low = sv-VisitorUuid ) INTO TABLE visitor_uuids.
        INSERT VALUE #( sign = 'I' option = 'EQ' low = sv-ParentUuid  ) INTO TABLE mf_uuids.
      ENDLOOP.

      SORT visitor_uuids BY low.
      DELETE ADJACENT DUPLICATES FROM visitor_uuids COMPARING low.
      SORT mf_uuids BY low.
      DELETE ADJACENT DUPLICATES FROM mf_uuids COMPARING low.

      SELECT Uuid, Name, Email
        FROM zpra_mf_r_visitor
        WHERE Uuid IN @visitor_uuids
        INTO TABLE @DATA(visitors_bulk)
        PRIVILEGED ACCESS.

      SELECT Uuid, Title, Description, EventDateTime
        FROM zpra_mf_r_musicfestival
        WHERE Uuid IN @mf_uuids
        INTO TABLE @DATA(mf_bulk)
        PRIVILEGED ACCESS.

      LOOP AT status_visits INTO DATA(sv2).
        DATA(visitor_row) = VALUE #( visitors_bulk[ Uuid = sv2-VisitorUuid ] OPTIONAL ).
        DATA(mf_row)      = VALUE #( mf_bulk[ Uuid = sv2-ParentUuid ] OPTIONAL ).
        IF visitor_row-Email IS INITIAL OR mf_row-Uuid IS INITIAL. CONTINUE. ENDIF.

        queue_visit_status_email(
          visitor_name   = CONV string( visitor_row-Name )
          visitor_email  = CONV string( visitor_row-Email )
          mf_title       = CONV string( mf_row-Title )
          mf_description = mf_row-Description
          mf_eventdt     = mf_row-EventDateTime
          new_status     = sv2-Status ).
      ENDLOOP.
    ENDIF.

    DATA change_info TYPE TABLE OF string.
    DATA notif_text  TYPE TABLE OF string.

    IF lines( update_data_mf ) > 1.
      INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                      textid   = zcm_pra_mf_messages=>mass_update_not_supported
                      severity = if_abap_behv_message=>severity-warning ) )
             INTO TABLE reported_mf.
      RETURN.
    ENDIF.

    DATA(mf_changed) = VALUE #( update_data_mf[ 1 ] OPTIONAL ).
    IF mf_changed IS NOT INITIAL.

      IF mf_changed-%control-EventDateTime = if_abap_behv=>mk-on.
        APPEND 'Event Date/Time Changed' TO change_info.
        APPEND 'The date/time of an event you are registered for has been updated. Please update your calendar accordingly.' TO notif_text.
      ENDIF.

      IF mf_changed-%control-MaxVisitorsNumber = if_abap_behv=>mk-on.
        SELECT SINGLE max_visitors_number
          FROM zpra_mf_a_mf
          WHERE uuid = @mf_changed-Uuid
          INTO @DATA(old_capacity)
          PRIVILEGED ACCESS.
        DATA(capacity_info) = COND string(
            WHEN sy-subrc = 0
            THEN |Capacity Updated: { old_capacity } → { mf_changed-MaxVisitorsNumber }|
            ELSE 'Capacity Updated' ).
        APPEND capacity_info TO change_info.
        APPEND |The participant capacity for an event you are registered for has been updated from { old_capacity } to { mf_changed-MaxVisitorsNumber }.| TO notif_text.
      ENDIF.

      IF mf_changed-%control-is_project_created = if_abap_behv=>mk-on
         AND mf_changed-is_project_created EQ abap_true.
        APPEND 'Enterprise Project Linked' TO change_info.
        APPEND 'Great news! An Enterprise Project in S/4HANA Cloud has been successfully linked to this event.' TO notif_text.
      ENDIF.

      IF change_info IS NOT INITIAL.
        queue_booked_visitors_email(
          mf_uuid            = mf_changed-Uuid
          notification_text  = concat_lines_of( table = notif_text sep = `<br><br>` )
          change_info        = COND #( WHEN lines( change_info ) > 1
                                          THEN 'Event Details Updated'
                                          ELSE change_info[ 1 ] )
          new_event_datetime = COND #( WHEN mf_changed-%control-EventDateTime = if_abap_behv=>mk-on
                                       THEN mf_changed-EventDateTime ) ).
      ENDIF.
    ENDIF.

    " sendUpdate (manual) + all 4 automated triggers share this buffer
    LOOP AT zbp_pra_mf_r_musicfestival=>bgmc_email_processes INTO DATA(email_proc).
      TRY.
          email_proc->save_for_execution( ).
        CATCH cx_bgmc INTO DATA(email_exc).
          INSERT VALUE #( %msg = NEW zcm_pra_mf_messages(
                          textid         = zcm_pra_mf_messages=>error_bgpf_process_execution
                          severity       = if_abap_behv_message=>severity-error
                          exception_text = email_exc->get_longtext( ) ) )
                  INTO TABLE reported_mf.
      ENDTRY.
    ENDLOOP.
    CLEAR zbp_pra_mf_r_musicfestival=>bgmc_email_processes.
  ENDMETHOD.

  METHOD queue_visit_status_email.
    DATA datetime_str TYPE string.
    IF mf_eventdt IS NOT INITIAL.
      CONVERT UTCLONG mf_eventdt
              INTO DATE DATA(date) TIME DATA(time) TIME ZONE 'UTC'.
      datetime_str = |{ date DATE = ISO } { time TIME = ISO } (UTC)|.
    ENDIF.

    DATA trigger_msg TYPE string.
    IF new_status = zcl_pra_mf_enum_visit_status=>booked.
      trigger_msg = 'Your registration for the following event has been confirmed. We look forward to seeing you there!'.
    ELSE.
      trigger_msg = 'We regret to inform you that your registration for the following event has been cancelled. Please contact the organiser if you believe this is an error.'.
    ENDIF.

    DATA(subject) = |{ condense( mf_title ) } - { COND string( WHEN new_status = zcl_pra_mf_enum_visit_status=>booked
                                                                THEN 'Registration Confirmed'
                                                                ELSE 'Registration Cancelled' ) }|.

    DATA(body) =
      |{ trigger_msg }<br><br>| &
      |<table style="border-collapse:collapse;font-family:Arial,sans-serif;">| &
      |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Event</td>| &
      |<td style="padding:4px 0;">{ zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( mf_title ) ) }</td></tr>| &
      |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Theme</td>| &
      |<td style="padding:4px 0;">{ zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( mf_description ) ) }</td></tr>| &
      |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Date</td>| &
      |<td style="padding:4px 0;">{ datetime_str }</td></tr>| &
      |</table>|.

    TRY.
        DATA(email_op) = NEW zcl_pra_mf_bgmc_op_email_util(
            VALUE zcl_pra_mf_bgmc_op_email_util=>email_request_structure(
                visitor_name  = visitor_name
                email_address = condense( visitor_email )
                subject       = subject
                message_body  = body ) ).
        DATA(process) = cl_bgmc_process_factory=>get_default(
            )->create(
            )->set_name( 'MF_NOTIFY_EMAIL'
            )->set_operation_tx_uncontrolled( email_op ).
        APPEND process TO zbp_pra_mf_r_musicfestival=>bgmc_email_processes.
      CATCH cx_bgmc ##NO_HANDLER.
        " Silently skip - do not block save
    ENDTRY.
  ENDMETHOD.

  METHOD queue_booked_visitors_email.
    SELECT SINGLE Title, Description, EventDateTime
      FROM zpra_mf_r_musicfestival
      WHERE Uuid = @mf_uuid
      INTO @DATA(music_fest)
      PRIVILEGED ACCESS.
    IF sy-subrc <> 0. RETURN. ENDIF.
    DATA old_datetime_str TYPE string.
    IF music_fest-EventDateTime IS NOT INITIAL.
      CONVERT UTCLONG music_fest-EventDateTime
              INTO DATE DATA(date) TIME DATA(time) TIME ZONE 'UTC'.
      old_datetime_str = |{ date DATE = ISO } { time TIME = ISO } (UTC)|.
    ENDIF.

    DATA date_row TYPE string.
    IF new_event_datetime IS NOT INITIAL.
      CONVERT UTCLONG new_event_datetime
              INTO DATE DATA(new_date) TIME DATA(new_time) TIME ZONE 'UTC'.
      DATA(new_datetime_str) = |{ new_date DATE = ISO } { new_time TIME = ISO } (UTC)|.
      date_row =
        |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Date</td>| &
        |<td style="padding:4px 0;"><s>{ old_datetime_str }</s> → { new_datetime_str }</td></tr>|.
    ELSE.
      date_row =
        |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Date</td>| &
        |<td style="padding:4px 0;">{ old_datetime_str }</td></tr>|.
    ENDIF.

    SELECT visit~VisitorUuid, visitor~Name, visitor~Email
      FROM zpra_mf_r_visit AS visit
      INNER JOIN zpra_mf_r_visitor AS visitor
        ON visitor~Uuid = visit~VisitorUuid
      WHERE visit~ParentUuid = @mf_uuid
        AND visit~Status     = @zcl_pra_mf_enum_visit_status=>booked
        AND visitor~Email    IS NOT INITIAL
      INTO TABLE @DATA(booked_visitors)
      PRIVILEGED ACCESS.
    CHECK booked_visitors IS NOT INITIAL.

    DATA(event_table) =
      |<table style="border-collapse:collapse;font-family:Arial,sans-serif;">| &
      |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Event</td>| &
      |<td style="padding:4px 0;">{ zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( CONV string( music_fest-Title ) ) ) }</td></tr>| &
      |<tr><td style="padding:4px 16px 4px 0;font-weight:bold;vertical-align:top;">Theme</td>| &
      |<td style="padding:4px 0;">{ zcl_pra_mf_bgmc_op_email_util=>escape_html( condense( CONV string( music_fest-Description ) ) ) }</td></tr>| &
      |{ date_row }| &
      |</table>|.

    DATA subject TYPE string.
    subject = |{ condense( CONV string( music_fest-Title ) ) } - { change_info }|.

    LOOP AT booked_visitors INTO DATA(booked_visitor).
      DATA email TYPE string.
      email = condense( CONV string( booked_visitor-Email ) ).
      DATA(body) = |{ notification_text }<br><br>{ event_table }|.
      TRY.
          DATA(email_op) = NEW zcl_pra_mf_bgmc_op_email_util(
              VALUE zcl_pra_mf_bgmc_op_email_util=>email_request_structure(
                  visitor_name  = booked_visitor-Name
                  email_address = email
                  subject       = subject
                  message_body  = body ) ).
          DATA(process) = cl_bgmc_process_factory=>get_default(
              )->create(
              )->set_name( 'MF_NOTIFY_EMAIL'
              )->set_operation_tx_uncontrolled( email_op ).
          APPEND process TO zbp_pra_mf_r_musicfestival=>bgmc_email_processes.
        CATCH cx_bgmc ##NO_HANDLER.
          " Silently skip - continue with remaining visitors
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
