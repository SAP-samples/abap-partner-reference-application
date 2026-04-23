# Add SAP BTP Applications into SAP S/4HANA Cloud Public Edition Launchpad

The **Music Festival Manager** apps can be added to SAP S/4HANA Cloud Public Edition launchpad to enable music festival managers to launch all relevant applications from a single launchpad.

Typically, customers have SAP S/4HANA Cloud tenants for customizing, test, and productive use. In such a setup, the custom tile is created in the customizing tenant and transported to the test and productive tenants using the software collections.

1. In the SAP S/4HANA Cloud tenant, to create a custom tile, open the **Custom Tiles** app and add a new tile with the following field values:

    | Field        | Value                                                                                          |
    | :----------- | :--------------------------------------------------------------------------------------------- |
    | *Title*:     | `Music Festivals`                                                                               |
    | *ID*:        | `MUSICFESTIVALS`                                                                                |
    | *Subtitle*:  | `Manage Music Festivals`                                                                        |
    | *URL*:       | Enter the **SAP BTP Application: Manage Music Festivals Tenant URL** |
    | *Icon*:      | Choose an icon, for example, *sap-icon://microphone*.                                          |

2. Choose **Assign Catalogs** and add a business catalog, for example, *Enterprise Projects - Project Management (Catalog ID - SAP_PPM_BC_PROJ_MGMT_PC)*.

3. Choose **Publish**. Continue once the status changes to *Published*.

4. Open the **App Finder** in your user profile and search for the added app title in the catalog search.

    > Note: Optionally, you can assign the app to a different or to a new app group.

    > Note: Refresh your browser window if the app is not listed.

5. Repeat the previous steps for the **Manage Visitors** app. Use the **SAP BTP Application: Manage Visitors Tenant URL** as URL.

You can now see the **Manage Music Festivals** and **Manage Visitors** apps on your SAP S/4HANA Cloud Public Edition launchpad in the **Project Control Management** group.
