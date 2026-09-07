@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection of Music Festival API Service'
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_MF'
@ObjectModel.semanticKey: [ 'ID' ]

define root view entity ZPRA_MF_C_MUSICFESTIVAL_API
  provider contract transactional_query
  as projection on ZPRA_MF_R_MUSICFESTIVAL

{
  key     Uuid,
          ID,
          Title,
          Description,
          EventDateTime,
          MaxVisitorsNumber,
          FreeVisitorSeats,

          @Semantics.amount.currencyCode: 'VisitorsFeeCurrency'
          VisitorsFeeAmount,
          VisitorsFeeCurrency,

          @Consumption.valueHelpDefinition: [ { entity: { name: 'ZPRA_MF_I_Music_Fest_Status_VH', element: 'Value' },
                                                useForValidation: true } ]
          @ObjectModel.text.element: [ 'StatusText' ]
          Status,

          /* Fetching the description via the association defined in the Base View */
          _Status.Description as StatusText,

          @Consumption.semanticObject: 'SalesOrder'
          @Consumption.semanticObjectMapping.element: 'SalesOrder'
          SalesOrderId,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
  virtual SalesOrderUrl : abap.string(256),

          BusinessPartnerId,
          BusinessPartnerName,

          _Visits : redirected to composition child ZPRA_MF_C_VISIT_API,
          _Status
}
