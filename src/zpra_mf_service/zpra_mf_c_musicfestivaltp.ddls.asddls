@Metadata.allowExtensions: true
@EndUserText.label: 'Music Fest Manage App'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_MF'
@ObjectModel.semanticKey: ['ID']
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER  ]
@AbapCatalog.extensibility: {
  extensible: true,
  dataSources: ['MusicFestivalBase']
}

define root view entity ZPRA_MF_C_MUSICFESTIVALTP
  provider contract transactional_query
  as projection on ZPRA_MF_R_MUSICFESTIVAL as MusicFestivalBase
{
  key     Uuid,
          ID,
          Title,
          Description,
          EventDateTime,
          MaxVisitorsNumber,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
          @Semantics.mimeType: true
  virtual MimeType           : abap.char(32),

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
          @Semantics.mimeType: true
  virtual HyperLinkText      : zpra_mf_title,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
          @Semantics.largeObject.contentDispositionPreference: #INLINE
          @Semantics.largeObject.mimeType: 'mimeType'
          @Semantics.largeObject.fileName: 'HyperLinkText'
  virtual OutputPdfData      : zpra_mf_form,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
  virtual BookedSeats        : abap.int4,
          FreeVisitorSeats,
          VisitorsFeeAmount,
          @Semantics.currencyCode: true
          VisitorsFeeCurrency,

          @ObjectModel.text.element: ['StatusText']
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZPRA_MF_I_Music_Fest_Status_VH', element: 'Value' }, useForValidation: true}]
          Status,
          _Status.Description as StatusText,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
  virtual StatusCriticality  : abap.int4,

          CreatedBy,
          CreatedAt,
          LastChangedAt,
          LastChangedBy,
          LocalLastChangedAt,

          project_id,
          SalesOrderId,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
  virtual SalesOrderUrl      : abap.string( 256 ),

          BusinessPartnerId,
          BusinessPartnerName,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
  virtual HideSponsoringData : abap_boolean,

          @UI.hidden: false
          @ObjectModel.filter.enabled: false
          @ObjectModel.sort.enabled: false
          _Proj,
          _Visits : redirected to composition child ZPRA_MF_C_VISITTP

}
