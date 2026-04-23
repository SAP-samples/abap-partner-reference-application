@EndUserText.label: 'Abstract Entity for MF Event Updated'
@Metadata.allowExtensions: true
@ObjectModel.supportedCapabilities: [#DATA_STRUCTURE]
define root abstract entity ZPRA_MF_D_MUSICEVENTUPDATED
{
  @EndUserText.label: 'Event Title'
  Title               : zpra_mf_title;
  @EndUserText.label: 'Event Status'
  Status              : zpra_mf_music_fest_status_code;
  @EndUserText.label: 'Max Number of Visitors'
  MaxVisitorsNumber   : zpra_mf_max_visitors_number;
  @EndUserText.label: 'Available Seats'
  FreeVisitorSeats    : zpra_mf_free_visitor_seats;
  @EndUserText.label: 'Price'
  VisitorsFeeAmount   : zpra_mf_price;
  @EndUserText.label: 'Currency'
  VisitorsFeeCurrency : zpra_mf_currency_code;
  @EndUserText.label: 'Event Date and Time'
  EventDateTime       : zpra_mf_date_time;
  @EndUserText.label: 'Artist Name'
  ArtistName          : zpra_mf_name;
  __before : composition[1..1] of ZPRA_MF_D_MUSICEVENTUPDTD_OLD;
}
