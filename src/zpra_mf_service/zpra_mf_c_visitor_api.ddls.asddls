@EndUserText.label: 'Projection - ZPRA_MF_R_VISITOR API'
@AccessControl.authorizationCheck: #CHECK

define root view entity ZPRA_MF_C_VISITOR_API
  provider contract transactional_query
  as projection on ZPRA_MF_R_Visitor
{
  key Uuid,
      Name,
      Email,
      
      _Visits : redirected to ZPRA_MF_C_VISIT_API 
}
