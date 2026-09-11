@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Music Festival - Base View'
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_MF'
@AbapCatalog.extensibility: {
  extensible: true,
  dataSources: ['MusicFestival']
}
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */

define root view entity ZPRA_MF_R_MUSICFESTIVAL
  as select from zpra_mf_a_mf as MusicFestival
  composition [0..*] of ZPRA_MF_R_VISIT                as _Visits
  association [1..1] to ZPRA_MF_I_Music_Fest_Status_VH as _Status on $projection.Status = _Status.Value
  association [0..1] to ZPRA_MF_AE_REMOTE_PROJ         as _Proj   on _Proj.ProjectID = $projection.project_id
{
  key uuid                  as Uuid,
      id                    as ID,
      title                 as Title,
      description           as Description,
      event_date_time       as EventDateTime,
      max_visitors_number   as MaxVisitorsNumber,
      free_visitor_seats    as FreeVisitorSeats,
      @Semantics.amount.currencyCode : 'VisitorsFeeCurrency'
      visitors_fee_amount   as VisitorsFeeAmount,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'I_CurrencyStdVH',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      visitors_fee_currency as VisitorsFeeCurrency,
      status                as Status,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      project_id            as project_id,
      is_project_created    as is_project_created,
      project_log_handle    as project_log_handle,
      is_project_crea_trig  as is_project_crea_trig,
      sales_order_id        as SalesOrderId,
      business_partner_id   as BusinessPartnerId,
      business_partner_name as BusinessPartnerName,

      //Associations
      _Visits,
      _Status,
      _Proj
      //  @UI.hidden: true

}
