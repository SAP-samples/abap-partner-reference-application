CLASS zcm_pra_mf_messages DEFINITION
  PUBLIC
     INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS',

      BEGIN OF state_area,
        validate_event    TYPE string VALUE 'VALIDATE_EVENT',
        validate_visitors TYPE String VALUE 'VALIDATE_VISITORS',
        validate_date     TYPE string VALUE 'VALIDATE_DATE',
        validate_publish_action TYPE string VALUE 'VALIDATE_PUBLISH_ACTION',
      END OF state_area,

      BEGIN OF max_visitor_zero_negative,
        msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF max_visitor_zero_negative,

      BEGIN OF max_visitors_less_than_booked,
        msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF max_visitors_less_than_booked,

      BEGIN OF event_datetime_invalid,
        msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF event_datetime_invalid,

      BEGIN OF event_mandatory_value_missing,
        msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF event_mandatory_value_missing,

      BEGIN OF event_already_published,
        msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'TITLE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF event_already_published,

      BEGIN OF error_in_proj_creation,
        msgid TYPE symsgid VALUE 'ZPRA_MF_MSG_CLS',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'TITLE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_in_proj_creation.


    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        attr1    TYPE string OPTIONAL
        attr2    TYPE string OPTIONAL
        attr3    TYPE string OPTIONAL
        attr4    TYPE string OPTIONAL
        title    TYPE zpra_mf_title OPTIONAL
        previous LIKE previous OPTIONAL
        severity TYPE if_abap_behv_message=>t_severity OPTIONAL
        uname    TYPE syuname OPTIONAL.

    DATA:
      mv_attr1 TYPE string,
      mv_attr2 TYPE string,
      mv_attr3 TYPE string,
      mv_attr4 TYPE string,
      title TYPE zpra_mf_title,
      mv_uname TYPE syuname.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_pra_mf_messages IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    me->mv_attr1                 = attr1.
    me->mv_attr2                 = attr2.
    me->mv_attr3                 = attr3.
    me->mv_attr4                 = attr4.
    me->mv_uname                 = uname.
    me->title                    = title.

    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
