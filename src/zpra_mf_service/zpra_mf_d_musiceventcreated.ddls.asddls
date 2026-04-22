@EndUserText.label: 'Abstract Entity for MF Event Created'
@Metadata.allowExtensions: true
@ObjectModel.supportedCapabilities: [#DATA_STRUCTURE]
define abstract entity ZPRA_MF_D_MUSICEVENTCREATED
{ 
  @EndUserText.label: 'Event Title'
  Title         : zpra_mf_title;
  @EndUserText.label: 'Event Date and Time'
  EventDateTime : zpra_mf_date_time;
  @EndUserText.label: 'Event Status'
  Status        : zpra_mf_music_fest_status_code;
}
