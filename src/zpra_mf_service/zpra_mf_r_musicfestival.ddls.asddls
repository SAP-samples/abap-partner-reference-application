@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_MF'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZPRA_MF_R_MusicFestival
  as select from zpra_mf_a_mf as MusicFestival
  composition [0..*] of ZPRA_MF_R_VISIT                   as _Visits
  association [1..1] to ZPRA_MF_I_Music_Fest_Status_VH as _Status on $projection.Status = _Status.Value
{
  key uuid                  as Uuid,
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

      //Associations
      _Visits,
      _Status
      //      _proj
      //  @UI.hidden: true

}
