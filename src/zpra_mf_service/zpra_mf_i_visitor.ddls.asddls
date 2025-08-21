@AbapCatalog.sqlViewName: 'ZPRA_MF_VSTR'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visitors Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view ZPRA_MF_I_Visitor as select from zpra_mf_a_vstr as Visitor
{

    @ObjectModel.text.element: ['VisitorName']
      @UI.textArrangement: #TEXT_ONLY
      @UI.hidden: true
 
  key Visitor.uuid  as VisitorId,
      
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      Visitor.name  as VisitorName,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      Visitor.email as VisitorEmail
  
}
