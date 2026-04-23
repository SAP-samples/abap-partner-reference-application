CLASS zcl_pra_mf_printqueue_vh DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS ZCL_PRA_MF_PRINTQUEUE_VH IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(print_queues) = cl_print_queue_utils=>get_pqname_list( ).
    DATA print_queues_vh TYPE STANDARD TABLE OF zpra_mf_ce_printqueue_vh.

    print_queues_vh =
      VALUE #( FOR queue IN print_queues
               ( print_queue = queue ) ).

    IF io_request->is_data_requested( ).
      io_response->set_data( print_queues_vh ).
    ENDIF.

    " Set total number of records
    io_response->set_total_number_of_records( lines( print_queues_vh ) ).

    " These two methods are needed for the full query provider implementation.
    io_request->get_sort_elements( ).
    io_request->get_paging( ).
  ENDMETHOD.
ENDCLASS.
