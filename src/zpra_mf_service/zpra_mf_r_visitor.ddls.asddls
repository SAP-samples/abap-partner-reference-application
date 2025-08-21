@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_VSTR'
define root view entity ZPRA_MF_R_Visitor
  as select from zpra_mf_a_vstr as Visitor
   association [1..*] to ZPRA_MF_R_VISIT as _Visits on $projection.Uuid = _Visits.VisitorUuid
{
  key uuid as Uuid,
  name as Name,
  email as Email,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  
  //local ETag field --> OData ETag
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
      
  _Visits
  
}
