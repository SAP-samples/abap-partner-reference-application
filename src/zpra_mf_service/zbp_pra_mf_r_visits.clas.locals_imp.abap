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

    "Determinations
    METHODS determineStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Visits~determineStatus.
    METHODS determineAvailableSeats FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Visits~determineAvailableSeats.

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


ENDCLASS.
