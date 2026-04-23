@EndUserText.label: 'Abstract Entity Visit Booked & Cancelled'
//@VDM.usage.type: [#EVENT_SIGNATURE]
@Metadata.allowExtensions: true
@ObjectModel.supportedCapabilities: [#DATA_STRUCTURE]
define abstract entity ZPRA_MF_D_VISIT
{
      ParentUuid  : sysuuid_x16;
      VisitorUuid : sysuuid_x16;
      @EndUserText.label: 'Visitor Name'
      name        : zpra_mf_name;
}
