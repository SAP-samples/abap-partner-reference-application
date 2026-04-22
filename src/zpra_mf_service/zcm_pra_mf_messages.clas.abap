CLASS zcm_pra_mf_messages DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.
    INTERFACES if_abap_behv_message.

    CONSTANTS gc_msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS'.

    CONSTANTS: BEGIN OF state_area,
                 validate_event          TYPE string VALUE 'VALIDATE_EVENT',
                 validate_visitors       TYPE String VALUE 'VALIDATE_VISITORS',
                 validate_date           TYPE string VALUE 'VALIDATE_DATE',
                 validate_publish_action TYPE string VALUE 'VALIDATE_PUBLISH_ACTION',
               END OF state_area.

    CONSTANTS: BEGIN OF default,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '000',
                 attr1 TYPE scx_attrname VALUE 'MV_ATTR1',
                 attr2 TYPE scx_attrname VALUE 'MV_ATTR2',
                 attr3 TYPE scx_attrname VALUE 'MV_ATTR3',
                 attr4 TYPE scx_attrname VALUE 'MV_ATTR4',
               END OF default.

    CONSTANTS: BEGIN OF max_visitor_zero_negative,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '001',
                 attr1 TYPE scx_attrname VALUE '',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF max_visitor_zero_negative.

    CONSTANTS: BEGIN OF max_visitors_less_than_booked,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '002',
                 attr1 TYPE scx_attrname VALUE '',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF max_visitors_less_than_booked.

    CONSTANTS: BEGIN OF event_datetime_invalid,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '003',
                 attr1 TYPE scx_attrname VALUE '',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF event_datetime_invalid.

    CONSTANTS: BEGIN OF event_mandatory_value_missing,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '004',
                 attr1 TYPE scx_attrname VALUE '',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF event_mandatory_value_missing.

    CONSTANTS: BEGIN OF create_with_ai_failed,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '005',
                 attr1 TYPE scx_attrname VALUE 'EXCEPTION_TEXT',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF create_with_ai_failed.

    CONSTANTS: BEGIN OF scenario_not_configured,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '006',
                 attr1 TYPE scx_attrname VALUE 'SCENARIO_ID',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF scenario_not_configured.

    CONSTANTS: BEGIN OF error_bgpf_process_creation,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '007',
                 attr1 TYPE scx_attrname VALUE 'EXCEPTION_TEXT',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF error_bgpf_process_creation.

    CONSTANTS: BEGIN OF error_bgpf_process_execution,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '012',
                 attr1 TYPE scx_attrname VALUE 'EXCEPTION_TEXT',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF error_bgpf_process_execution.

    CONSTANTS: BEGIN OF error_in_proj_creation,
                 msgid TYPE symsgid      VALUE 'ZPRA_MF_MSG_CLS',
                 msgno TYPE symsgno      VALUE '010',
                 attr1 TYPE scx_attrname VALUE 'TITLE',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF error_in_proj_creation.

    METHODS constructor
      IMPORTING textid         LIKE if_t100_message=>t100key             OPTIONAL
                attr1          TYPE string                               OPTIONAL
                attr2          TYPE string                               OPTIONAL
                attr3          TYPE string                               OPTIONAL
                attr4          TYPE string                               OPTIONAL
                !title         TYPE zpra_mf_title                        OPTIONAL
                exception_text TYPE string                               OPTIONAL
                scenario_id    TYPE if_com_arrangement_v2=>ty_ca-cscn_id OPTIONAL
                !previous      LIKE previous                             OPTIONAL
                severity       TYPE if_abap_behv_message=>t_severity     OPTIONAL
                !uname         TYPE syuname                              OPTIONAL.

    DATA mv_attr1       TYPE string.
    DATA mv_attr2       TYPE string.
    DATA mv_attr3       TYPE string.
    DATA mv_attr4       TYPE string.
    DATA title          TYPE zpra_mf_title.
    DATA exception_text TYPE zpra_mf_title.
    DATA scenario_id    TYPE if_com_arrangement_v2=>ty_ca-cscn_id.
    DATA mv_uname       TYPE syuname.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCM_PRA_MF_MESSAGES IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    mv_attr1       = attr1.
    mv_attr2       = attr2.
    mv_attr3       = attr3.
    mv_attr4       = attr4.
    mv_uname       = uname.
    me->title          = title.
    me->exception_text = exception_text.
    me->scenario_id    = scenario_id.

    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
