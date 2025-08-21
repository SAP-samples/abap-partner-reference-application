@Metadata.allowExtensions: true
@EndUserText.label: 'Music Fest Manage App'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.sapObjectNodeType.name: 'ZPRA_MF_A_MF'
@ObjectModel.semanticKey: ['Title']
define root view entity ZPRA_MF_C_MusicFestivalTP
  provider contract transactional_query
  as projection on ZPRA_MF_R_MusicFestival as _music
  association to ZPRA_MF_AE_REMOTE_PROJ as _proj on _proj.ProjectID = _music.project_id
{
  key     Uuid,
          Title,
          Description,
          EventDateTime,
          MaxVisitorsNumber,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
  virtual BookedSeats       : abap.int4,
          FreeVisitorSeats,
          VisitorsFeeAmount,
          @Semantics.currencyCode: true
          VisitorsFeeCurrency,

          @ObjectModel.text.element: ['StatusText']
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZPRA_MF_I_Music_Fest_Status_VH', element: 'Value' }, useForValidation: true}]
          Status,
          _Status.Description as StatusText,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PRA_MF_CALC_MF_ELEMENTS'
  virtual StatusCriticality : abap.int4,

          CreatedBy,
          CreatedAt,
          LastChangedAt,
          LastChangedBy,
          LocalLastChangedAt,

          project_id,
          @UI.hidden: false
          @ObjectModel.filter.enabled: false
          @ObjectModel.sort.enabled: false
          _proj,
          _Visits : redirected to composition child ZPRA_MF_C_VISITTP

}
