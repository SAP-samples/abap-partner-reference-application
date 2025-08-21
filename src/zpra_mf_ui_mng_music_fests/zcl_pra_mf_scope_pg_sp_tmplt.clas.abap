CLASS zcl_pra_mf_scope_pg_sp_tmplt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRA_MF_SCOPE_PG_SP_TMPLT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(lo_scope_api) = cl_aps_bc_scope_change_api=>create_instance( ).

    lo_scope_api->scope(
      EXPORTING
        it_object_scope = VALUE #(
                            pgmid = if_aps_bc_scope_change_api=>gc_tadir_pgmid-r3tr
                            scope_state = if_aps_bc_scope_change_api=>gc_scope_state-on

                            " Space template
                            ( object = if_aps_bc_scope_change_api=>gc_tadir_object-uist obj_name = 'ZPRA_MF_LST' )

                            " Page template
                            ( object = if_aps_bc_scope_change_api=>gc_tadir_object-uipg obj_name = 'ZPRA_MF_LPT' )

                          )
        iv_simulate = abap_false
        iv_force = abap_false
      IMPORTING et_object_result = DATA(lt_results)
        et_message = DATA(lt_messages)
    ).

    " Check if the operation was successful
    IF lt_messages IS NOT INITIAL.
      " Print success message
      out->write( 'Scope operation completed successfully.' ) ##NO_TEXT.
    ELSE.
      " Optionally handle errors
      out->write( 'Scope operation encountered errors.' ) ##NO_TEXT.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
