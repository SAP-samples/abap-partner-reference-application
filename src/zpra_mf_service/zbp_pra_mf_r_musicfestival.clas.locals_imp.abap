" local test classes
CLASS ltc_validation_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltc_action_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltcl_determination_methods DEFINITION DEFERRED FOR TESTING.
CLASS ltc_authorization_methods DEFINITION DEFERRED FOR TESTING.

CLASS lhc_zpra_mf_r_musicfestival DEFINITION INHERITING FROM cl_abap_behavior_handler
FRIENDS ltc_validation_methods ltc_action_methods ltcl_determination_methods ltc_authorization_methods.

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

    "Validations
    METHODS validateMandatoryValue FOR VALIDATE ON SAVE
      IMPORTING keys FOR MusicFestival~validateMandatoryValue.
    METHODS validateMaxVisitors FOR VALIDATE ON SAVE
      IMPORTING keys FOR MusicFestival~validateMaxVisitors.
    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR MusicFestival~validateDate.

    "Determinations
    METHODS determineStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MusicFestival~determineStatus.
    METHODS determineAvailableSeats FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MusicFestival~determineAvailableSeats.

    "Actions
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
    METHODS GetDefaultsForCreate FOR READ
      IMPORTING keys FOR FUNCTION MusicFestival~GetDefaultsForCreate RESULT result.
    METHODS createWithAI FOR MODIFY
      IMPORTING keys FOR ACTION MusicFestival~createWithAI.


    "Class Methods not linked to BO
    METHODS getAIService
      RETURNING VALUE(result) TYPE REF TO zif_pra_mf_gen_ai_util.

ENDCLASS.

CLASS lhc_zpra_mf_r_musicfestival IMPLEMENTATION.
  METHOD get_global_authorizations.
    IF requested_authorizations-%create EQ if_abap_behv=>mk-on.
*     check create authorization
      AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO' ID 'ACTVT' FIELD '01'.
      result-%create = COND #( WHEN sy-subrc = 0 THEN
      if_abap_behv=>auth-allowed ELSE
      if_abap_behv=>auth-unauthorized ).
    ENDIF.

    IF requested_authorizations-%update EQ if_abap_behv=>mk-on.
*     check update authorization
      AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO' ID 'ACTVT' FIELD '02'.
      result-%update = COND #( WHEN sy-subrc = 0 THEN
      if_abap_behv=>auth-allowed ELSE
      if_abap_behv=>auth-unauthorized ).
    ENDIF.

    IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.
*     check delete authorization
      AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO' ID 'ACTVT' FIELD '06'.
      result-%delete = COND #( WHEN sy-subrc = 0 THEN
      if_abap_behv=>auth-allowed ELSE
      if_abap_behv=>auth-unauthorized ).
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_authorizations.
    DATA: update_requested TYPE abap_bool.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
    ENTITY MusicFestival
    FIELDS ( Uuid ) WITH CORRESPONDING #( keys )
    RESULT DATA(events)
    FAILED failed.

    CHECK events IS NOT INITIAL.

    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
                                    requested_authorizations-%delete = if_abap_behv=>mk-on OR
                                    requested_authorizations-%action-publish = if_abap_behv=>mk-on
                                    THEN
                                    abap_true ELSE abap_false ).

    LOOP AT events ASSIGNING FIELD-SYMBOL(<lfs_events>).
      IF update_requested = abap_true.
        "check authorization
        AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO'
        ID 'ACTVT' FIELD '02'.
        IF sy-subrc NE 0.
          APPEND VALUE #( %tky            = <lfs_events>-%tky
                          %update         = if_abap_behv=>auth-unauthorized
                          %delete         = if_abap_behv=>auth-unauthorized
                          %action-edit    = if_abap_behv=>auth-unauthorized
                          %action-publish = if_abap_behv=>auth-unauthorized
                          %action-crproj  = if_abap_behv=>auth-unauthorized ) TO result.
        ENDIF.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    DATA: music_festivals TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival.

    " Logic to enable create button only when status is Published
    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY MusicFestival
         FIELDS ( Status project_id  )
         WITH CORRESPONDING #( keys )
      RESULT music_festivals
      FAILED DATA(read_failed).

    DATA(music_festival) = VALUE #( music_festivals[ 1 ] OPTIONAL ).

    result = VALUE #( FOR event IN music_festivals
                      ( %tky = event-%tky
                        %features-%assoc-_Visits = COND #(
                          WHEN event-Status = zcl_pra_mf_enum_mf_status=>published
                            THEN if_abap_behv=>fc-o-enabled
                            ELSE if_abap_behv=>fc-o-disabled )

                        %features-%action-publish = COND #(
                          WHEN event-%is_draft = if_abap_behv=>mk-off AND
                               event-Status NE zcl_pra_mf_enum_mf_status=>published AND
                               event-Status NE zcl_pra_mf_enum_mf_status=>fully_booked
                            THEN if_abap_behv=>fc-o-enabled
                            ELSE if_abap_behv=>fc-o-disabled )

                        %features-%delete = COND #(
                          WHEN event-Status = zcl_pra_mf_enum_mf_status=>published OR
                               event-Status = zcl_pra_mf_enum_mf_status=>fully_booked
                            THEN if_abap_behv=>fc-o-disabled
                            ELSE if_abap_behv=>fc-o-enabled )

                        %features-%action-cancel = COND #(
                          WHEN event-%is_draft = if_abap_behv=>mk-off
                            THEN if_abap_behv=>fc-o-enabled
                            ELSE if_abap_behv=>fc-o-disabled )

                        %features-%action-CrProj = COND #(
                          WHEN event-Status = zcl_pra_mf_enum_mf_status=>published AND
                               music_festival-project_id IS INITIAL
                            THEN if_abap_behv=>fc-o-enabled
                            ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD validateMandatoryValue.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY MusicFestival
        FIELDS ( Title EventDateTime MaxVisitorsNumber )
        WITH CORRESPONDING #( keys )
        RESULT DATA(events).

    LOOP AT events REFERENCE INTO DATA(event).

      INSERT VALUE #( %tky = event->%tky %state_area = zcm_pra_mf_messages=>state_area-validate_event ) INTO TABLE reported-musicfestival.

      IF event->Title IS INITIAL OR
         event->EventDateTime IS INITIAL OR
         event->MaxVisitorsNumber IS INITIAL.

        INSERT VALUE #( %tky = event->%tky ) INTO TABLE failed-musicfestival.
        INSERT VALUE #(
          %tky = event->%tky
          %state_area = zcm_pra_mf_messages=>state_area-validate_event
          "Fill in all mandatory fields to proceed.
          %msg = NEW zcm_pra_mf_messages( textid = zcm_pra_mf_messages=>event_mandatory_value_missing
                                          severity = if_abap_behv_message=>severity-error )
          %element-Title = COND #( WHEN event->Title IS INITIAL
                                   THEN if_abap_behv=>mk-on
                                   ELSE if_abap_behv=>mk-off )
          %element-EventDateTime = COND #( WHEN event->EventDateTime IS INITIAL
                                           THEN if_abap_behv=>mk-on
                                           ELSE if_abap_behv=>mk-off )
          %element-MaxVisitorsNumber = COND #( WHEN event->MaxVisitorsNumber IS INITIAL
                                               THEN if_abap_behv=>mk-on
                                               ELSE if_abap_behv=>mk-off ) ) INTO TABLE reported-musicfestival.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateMaxVisitors.

    DATA: booked_visitors TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival\\Visits.

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
                        "Maximum visitors must be greater than zero.
                        %msg                       = NEW zcm_pra_mf_messages( textid   = zcm_pra_mf_messages=>max_visitor_zero_negative
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
        INSERT VALUE #( %tky                       = event->%tky
                        %state_area                = zcm_pra_mf_messages=>state_area-validate_visitors
                        "Maximum visitors must be equal to or greater than booked visitors.
                        %msg                       = NEW zcm_pra_mf_messages( textid   = zcm_pra_mf_messages=>max_visitors_less_than_booked
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

      INSERT VALUE #( %tky = event->%tky %state_area = zcm_pra_mf_messages=>state_area-validate_date ) INTO TABLE reported-musicfestival.

      IF event->EventDateTime IS NOT INITIAL AND event->EventDateTime < utclong_current( ).

        INSERT VALUE #( %tky = event->%tky ) INTO TABLE failed-musicfestival.
        INSERT VALUE #( %tky                   = event->%tky
                        %state_area            = zcm_pra_mf_messages=>state_area-validate_date
                        "Event date and time must be in the future.
                        %msg                   = NEW zcm_pra_mf_messages( textid   = zcm_pra_mf_messages=>event_datetime_invalid
                                                                          severity = if_abap_behv_message=>severity-error )
                        %element-EventDateTime = if_abap_behv=>mk-on ) INTO TABLE reported-musicfestival.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD determineStatus.

    DATA: booked_visitors TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival\\Visits.

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

      event->Status = COND #( WHEN event->Status IS INITIAL
                              THEN zcl_pra_mf_enum_mf_status=>in_preparation
                              WHEN event->Status = zcl_pra_mf_enum_mf_status=>fully_booked AND event->MaxVisitorsNumber <> lines( booked_visitors )
                              THEN zcl_pra_mf_enum_mf_status=>published
                              WHEN event->MaxVisitorsNumber > 0 AND event->MaxVisitorsNumber = lines( booked_visitors )
                              THEN zcl_pra_mf_enum_mf_status=>fully_booked
                              ELSE event->Status ).
    ENDLOOP.

    CHECK lines( events ) > 0.

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

  METHOD calculateFreeVisitorSeats.

    DATA: booked_visitors TYPE TABLE FOR READ RESULT ZPRA_MF_R_MusicFestival\\Visits.

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

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY MusicFestival
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(events).

    IF events IS INITIAL.
      EXIT.
    ENDIF.

      DATA(event) = VALUE #( events[ 1 ] OPTIONAL ).

      DATA(project) = NEW zcl_pra_mf_ent_proj_outb_integ( ).

      project_details-project = event-Title.
      IF strlen( event-Description ) LE 60.
        project_details-project_description = event-Description.
      ELSE.
        project_details-project_description = event-Description+0(60).
      ENDIF.

      CONVERT UTCLONG
      event-EventDateTime
      INTO DATE DATA(event_date)
      TIME DATA(event_time)
      TIME ZONE 'UTC'.

      project_details-project_start_date = event_date - 30.
      project_details-project_end_date = event_date.

      TEST-SEAM create_project.
        project->create_entproject( EXPORTING project_details_in = project_details
                                    IMPORTING messages           = DATA(proj_message) ).
      END-TEST-SEAM.

      IF proj_message IS NOT INITIAL AND event-%tky IS NOT INITIAL.

        INSERT VALUE #(
          %tky               = event-%tky
          "Error in Project Creation
          %msg               = NEW zcm_pra_mf_messages( textid   = zcm_pra_mf_messages=>error_in_proj_creation
                                                        severity = if_abap_behv_message=>severity-error
                                                        title    = event-Title )
          %op-%action-crproj = if_abap_behv=>mk-on
          %element-Status    = if_abap_behv=>mk-on

        ) INTO TABLE reported-musicfestival.


      ELSEIF proj_message IS INITIAL.

        DATA music_fest TYPE zpra_mf_a_mf.

        music_fest-project_id = |MF_| && |{ to_upper( project_details-project ) }|.

        music_fest-uuid = event-Uuid.

        MODIFY ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
          ENTITY MusicFestival
          UPDATE FIELDS ( project_id )
          WITH VALUE #( FOR entity IN events
                        ( %tky       = entity-%tky
                          project_id = music_fest-project_id ) ).

      ENDIF.

    READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
      ENTITY MusicFestival
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(updated_entities).

  ENDMETHOD.


  METHOD generateSampleData.
    DATA create_visitors TYPE TABLE FOR CREATE ZPRA_MF_R_Visitor.
    DATA create_music_fests TYPE TABLE FOR CREATE ZPRA_MF_R_MusicFestival.
    DATA cba_music_fest_visits TYPE TABLE FOR CREATE ZPRA_MF_R_MusicFestival\_Visits.
    DATA action_music_fest_publish TYPE TABLE FOR ACTION IMPORT ZPRA_MF_R_MusicFestival~publish.
    DATA action_visits_book TYPE TABLE FOR ACTION IMPORT ZPRA_MF_R_MusicFestival\\Visits~book.

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

    cba_music_fest_visits = VALUE #( ( %cid_ref = `mf02`
                                       %target  = VALUE #(
                                                           ( %cid        = `mf02_1` VisitorUuid = visitors_mapping-visitor[ 2 ]-uuid )
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

  METHOD GetDefaultsForCreate.
    result = VALUE #( FOR key IN keys (
                      %cid                       = key-%cid
                      %param-VisitorsFeeCurrency = 'INR'
                      ) ).
  ENDMETHOD.

  METHOD createWithAI.

    TYPES: BEGIN OF mf_create_data_structure,
             cid          TYPE abp_behv_cid,
             is_draft     TYPE abp_behv_flag,
             llm_response TYPE zcl_pra_mf_gen_ai_util=>zif_pra_mf_gen_ai_util~llm_response_structure,
           END OF mf_create_data_structure.

    DATA mf_create_data TYPE TABLE OF mf_create_data_structure.

    IF NEW zcl_pra_mf_com_util(  )->is_scenario_configured( 'SAP_COM_0A69' ) = abap_false.
      "No active communication arrangement for scenario SCENARIO_ID found
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
          "Musical event creation with AI failed. Please try again. Error: EXCEPTION_TEXT
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
              WITH VALUE #( FOR line_item IN mf_create_data ( %cid        = line_item-cid
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


ENDCLASS.
