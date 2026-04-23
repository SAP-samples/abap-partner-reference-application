@EndUserText.label: 'AE for printGuestList action parm for MF'
define root abstract entity ZPRA_MF_AE_PrintGuestList
{
  @Consumption.valueHelpDefinition: [{
    entity: {name: 'ZPRA_MF_CE_PRINTQUEUE_VH', element: 'print_queue'}
  }]
  @EndUserText.label: 'Select Print Queue'
  print_queue: abap.char(32);
}
