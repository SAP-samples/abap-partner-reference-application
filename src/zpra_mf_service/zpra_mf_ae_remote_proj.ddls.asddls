@EndUserText.label: 'Custom Entity for remote project'
@Metadata.allowExtensions: true
@ObjectModel:{ query: { implementedBy: 'ABAP:ZCL_PRA_MF_FETCH_PROJ' } }

define custom entity ZPRA_MF_AE_REMOTE_PROJ
{

      @UI.facet:[{
        id:'Fieldgroup3',
        purpose:#STANDARD,
        type:#FIELDGROUP_REFERENCE,
        label:'Project Information',
        targetQualifier:'Fieldgroup3' ,
        position:220}]

      @UI         : {
      lineItem    : [{position: 220, importance: #HIGH}],
      identification      : [{position: 220}],
      fieldGroup  :[{groupLabel: 'Project Information', qualifier:'Fieldgroup3',position:220, importance: #HIGH, type:#WITH_URL, url: 'Nav' }]
      }
      @EndUserText.label  : 'Project ID'

  key ProjectID   : abap.char(24);

      @UI         : {
      lineItem    : [{position: 230, importance: #HIGH}],
      identification      : [{position: 230}],
      fieldGroup  :[{groupLabel: 'Project Information', qualifier:'Fieldgroup3',position:230, importance: #HIGH }]
      }
      @EndUserText.label  : 'Project Name'

      ProjectName : abap.char(40);
      
      @UI.hidden: true
      Nav : abap.char(120);

      @UI         : {
      lineItem    : [{position: 240, importance: #HIGH}],
      identification      : [{position: 240}],
      fieldGroup  :[{groupLabel: 'Project Information', qualifier:'Fieldgroup3',position:240, importance: #HIGH }]
      }
      @EndUserText.label  : 'Start Date'
      
      StartDate   : abap.dats;

      @UI         : {
      lineItem    : [{position: 250, importance: #HIGH}],
      identification      : [{position: 250}],
      fieldGroup  :[{groupLabel: 'Project Information', qualifier:'Fieldgroup3',position:250, importance: #HIGH }]
      }
      @EndUserText.label  : 'End Date'

      EndDate     : abap.dats;
      
      @UI         : {
      lineItem    : [{position: 260, importance: #HIGH}],
      identification      : [{position: 260}],
      fieldGroup  :[{groupLabel: 'Project Information', qualifier:'Fieldgroup3',position:260, importance: #HIGH }]
      }
      @EndUserText.label  : 'Responsible Cost Center'

      CostCenter     : abap.char(10);

      @UI         : {
      lineItem    : [{position: 270, importance: #HIGH}],
      identification      : [{position: 270}],
      fieldGroup  :[{groupLabel: 'Project Information', qualifier:'Fieldgroup3',position:270, importance: #HIGH }]
      }
      @EndUserText.label  : 'Processing Status'

      Status     : abap.char(10);
      
    
      
      
}
