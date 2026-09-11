@Metadata.allowExtensions: true
@EndUserText.label: 'View Entity for Visitor API Service'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_VSTR'
define view entity ZPRA_MF_C_VISIT_API
  as projection on ZPRA_MF_R_VISIT
{
    key Uuid,
    ParentUuid,
    VisitorUuid,
    ArtistIndicator,
    Status,
    _MusicFestival : redirected to parent ZPRA_MF_C_MUSICFESTIVAL_API,
    _Visitor          : redirected to ZPRA_MF_C_VISITOR_API,
    _VisitorVH
}
