@Metadata.allowExtensions: true
@EndUserText.label: 'Manage Visitor App'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_VSTR'
@ObjectModel.semanticKey: [ 'Name' ]
define root view entity ZPRA_MF_C_VisitorTP
  provider contract transactional_query
  as projection on ZPRA_MF_R_Visitor
{
  key Uuid,
  Name,
  Email,
  CreatedBy,
  CreatedAt,
  LastChangedAt,
  LastChangedBy,
  LocalLastChangedAt,
  _Visits : redirected to ZPRA_MF_C_VISITTP
  
}
