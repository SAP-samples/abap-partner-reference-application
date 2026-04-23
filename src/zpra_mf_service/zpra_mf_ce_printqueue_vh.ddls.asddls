@EndUserText.label: 'Custom entity for print queue value help'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PRA_MF_PRINTQUEUE_VH'
@ObjectModel.resultSet.sizeCategory: #XS
define custom entity ZPRA_MF_CE_PRINTQUEUE_VH
{
  key print_queue : abap.char(32);
}
