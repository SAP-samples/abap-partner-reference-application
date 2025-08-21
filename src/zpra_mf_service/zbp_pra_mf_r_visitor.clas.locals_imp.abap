CLASS LHC_ZPRA_MF_R_VISITOR DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Visitor
        RESULT result.
          METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
            IMPORTING keys REQUEST requested_authorizations FOR Visitor RESULT result.
ENDCLASS.

CLASS LHC_ZPRA_MF_R_VISITOR IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
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

        READ ENTITIES OF ZPRA_MF_R_Visitor  IN LOCAL MODE
        ENTITY Visitor
        FIELDS ( Uuid ) WITH CORRESPONDING #( keys )
        RESULT DATA(visits)
        FAILED failed.

    CHECK visits is not initial.

    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
                                    requested_authorizations-%delete = if_abap_behv=>mk-on OR
                                    requested_authorizations-%action-Edit = if_abap_behv=>mk-on
                                    THEN
                                    abap_true ELSE abap_false ).

         LOOP AT visits ASSIGNING FIELD-SYMBOL(<lfs_visits>).
        IF update_requested = abap_true.
          "check authorization
          AUTHORITY-CHECK OBJECT 'ZPRA_MF_AO'
            ID 'ACTVT' FIELD '02'.
          IF sy-subrc NE 0.
            APPEND VALUE #( %tky = <lfs_visits>-%tky
                            %update = if_abap_behv=>auth-unauthorized
                            %delete = if_abap_behv=>auth-unauthorized
                            %action-edit    = if_abap_behv=>auth-unauthorized ) TO result.
         ENDIF.
        ENDIF.
     ENDLOOP.
  ENDMETHOD.

ENDCLASS.
