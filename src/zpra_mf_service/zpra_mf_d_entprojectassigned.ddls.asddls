@EndUserText.label: 'Abstract Entity for Ent Project Asigned'
@Metadata.allowExtensions: true
@ObjectModel.supportedCapabilities: [#DATA_STRUCTURE]
define abstract entity ZPRA_MF_D_ENTPROJECTASSIGNED
{
  @EndUserText.label: 'Event Title'
  Title         : zpra_mf_title;
  @EndUserText.label: 'Event Date and Time'
  EventDateTime : zpra_mf_date_time;
  @EndUserText.label: 'Project ID'
  Project_Id    : abap.char(24);
}
