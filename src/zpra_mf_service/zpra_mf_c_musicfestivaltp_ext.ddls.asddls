extend view entity ZPRA_MF_C_MUSICFESTIVALTP with
{
  @EndUserText.label: 'ZZPRA_MF_MF_TEXT1'
  @EndUserText.quickInfo: 'ZZPRA_MF_MF_TEXT1'
  @ObjectModel.text.element: [ 'ZZPRA_MF_MF_TEXT1T' ]
  MUSICFESTIVALBASE.ZZPRA_MF_MF_TEXT1,
  @EndUserText.label: 'ZZPRA_MF_MF_TEXT1T'
  @EndUserText.quickInfo: 'ZZPRA_MF_MF_TEXT1T'
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PCF_GENERIC_TEXT_PROVIDER'
  virtual ZZPRA_MF_MF_TEXT1T : abap.char( 80 ),
  @EndUserText.label: 'ZZPRA_MF_MF_TEXT2'
  @EndUserText.quickInfo: 'ZZPRA_MF_MF_TEXT2'
  @ObjectModel.text.element: [ 'ZZPRA_MF_MF_TEXT2T' ]
  MUSICFESTIVALBASE.ZZPRA_MF_MF_TEXT2,
  @EndUserText.label: 'ZZPRA_MF_MF_TEXT2T'
  @EndUserText.quickInfo: 'ZZPRA_MF_MF_TEXT2T'
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PCF_GENERIC_TEXT_PROVIDER'
  virtual ZZPRA_MF_MF_TEXT2T : abap.char( 80 )
}
