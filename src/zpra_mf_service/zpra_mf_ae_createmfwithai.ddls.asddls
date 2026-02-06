@EndUserText.label: 'Parameters for createWithAI in MF entity'
@Metadata.allowExtensions: true
define root abstract entity ZPRA_MF_AE_CreateMFWithAI
{
  @EndUserText.label: 'Choose language for title & description'
  language : abap.char(16);

  @EndUserText.label: 'Add tags for title & description'
  @EndUserText.quickInfo: 'For example: creative, funny'
  tags     : zpra_mf_tags;

  @EndUserText.label: 'Generate the description in rhymes'
  @UI.defaultValue: 'X'
  rhyme    : zpra_mf_rhyme_indicator;
}
