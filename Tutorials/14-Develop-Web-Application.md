# Building a Fiori-Based Web Application using ABAP RAP

In this tutorial, you're creating a SAP Fiori UI for the Music Festivals OData service to efficiently manage music festival events.

## Prerequisites

1. **SAP Business Application Studio (SAP BAS) is enabled**: Ensure SAP BAS is activated, and a Dev space is created for your development. For setup instructions, refer to [Enable SAP Business Application Studio](./11-Prepare-BTP-Account-ADT-For-Dev.md#enable-sap-business-application-studio).
2. **Creating a service key for the ABAP system**: A service key is required for establishing a secure connection between SAP BAS and the ABAP system. You can create the service key through your BTP subaccount. For detailed instructions, refer to [Creating a Service Key for ABAP System](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-service-key-for-abap-system).
3. **Destination to ABAP system for SAP BAS is set up**: A destination to the ABAP system must be configured in your SAP BTP subaccount.
   - If SAP BAS and ABAP environment are in the same subaccount, follow [Creating a Destination to the ABAP System for SAP Business Application Studio](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-destination-to-abap-system-for-sap-business-application-studio).
   - For different subaccounts, configure cross-subaccount communication by following
     - **Subaccount with BAS**
       - [Create a Destination for Cross-Subaccount Communication](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-destination-for-cross-subaccount-communication), while configuring the destination additionally add `abap_cloud` to `WebIDEEnabled` parameter.
       - Download your subaccount-specific trust certificate by navigating to Connectivity -> Destinations -> Download Trust.
     - **Subaccount with ABAP Environment**
       - In abap environment follow [Creating a Communication System for SAP Business Application Studio](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-communication-system-for-sap-business-application-studio) using the trust certificate downloaded in previous step.

## Add a Web Application with SAP Fiori Elements

1. Open your Dev space in SAP BAS:
   - In SAP BAS, open the menu on the left and choose **File > Open Folder** to set your workspace.
   - Navigate to _/home/user/projects/_ and choose **OK**.

2. Set up the Cloud Foundry organization and space:
   - Choose **Settings** in SAP BAS and open the **Command Palette**.
   - Search for _CF: Login to Cloud Foundry_ and select it.
   - Paste your **Cloud Foundry API endpoint**, enter your credentials, and choose **Sign In**.
   - After logging in, set your Cloud Foundry target:
     1. **Cloud Foundry Organization**: _Enter the org name_
     2. **Cloud Foundry Space**: _Enter the space_

> [!TIP]
> You can find the Cloud Foundry API endpoint, organization name, and space on the **Overview** tab of your subaccount in the **SAP BTP cockpit**.

3. Select a template:
   - Ensure that the target folder path is set to _/home/user/projects_.
   - Go to **Settings** in SAP BAS and open the **Command Palette**.
   - Search for _Fiori: Open Application Generator_ and select it.
   - Choose **List Report Page** and then **Next**.

4. Enter the data source and select a service:
   - **Data source**: _Connect to a System_
   - **System**: _Enter the destination name_
   - **Service**: _Enter the service name_.

   Choose **Next**.

5. Select the entity:
   - **Main Entity**: _MusicFestival_
   - **Navigation Entity**: _\_Visits_
   - **Automatically add table columns to the list page and a section to the object page if none already exists?**: _Yes_
   - **Table Type**: _Responsive_

6. Enter the project attributes:
   - **Module Name**: _musicfestivals_
   - **Application Title**: _Music Festival Manager_
   - **Description**: _A Music Festival Manager application._
   - **Project Folder Path**: _/home/user/projects_
   - **Enable TypeScript**: _No_
   - **Add Deployment Configuration**: _Yes_
   - **Add FLP Configuration**: _Yes_
   - **Use Virtual Endpoints for Local Preview**: _Yes_
   - **Configure Advanced Options**: _No_

   Choose **Next**.

7. Enter the deployment configuration information:
   - **Please choose the target**: _ABAP_
   - **Destination**: _Enter the destination name_
   - **SAP UI5 ABAP Repository**: _ZPRA_MF_MF_
   - **How do you want to enter the package?**: _Enter manually_
   - **Package**: _ZPRA_MF_UI_MNG_MUSIC_FESTS_
   - **How do you want to enter the transport request?**: _Create new_

   Choose **Next**.

> [!TIP]
> To find your **transport request**, open Eclipse, search for your package, and check the _Transport Organizer_. Select the transport request of the superior folder under _Modifiable_.

8. Enter the SAP Fiori launchpad configuration:
   - **Semantic Object**: _ZPRA_MF_MF_
   - **Action**: _display_
   - **Title**: _Manage Music Festival_

   Choose **Finish**.

> [!NOTE]
> The wizard creates the _musicfestivals_ folder with all necessary UI files.

9. Preview the application:
   - Right-click on the **musicfestivals** folder and choose **Open Application Info**.
   - Choose **Preview Application** to view it running in a new browser tab.

10. Build and deploy the application:

- Navigate to the _musicfestivals_ folder in your command prompt.
- Run the `npm run build` command to build the app.
- Once the build is complete, run the `npm run deploy` command to deploy the app.

> [!NOTE]
> After deployment, you see the **BSP application** and the **Launchpad App Descriptor Items** under _Fiori User Interface_ in your _ADT_ within the _ZPRA_MF_UI_MNG_MUSIC_FESTS_ package. These items are used for configuring the IAM apps.

Similarly, you can create a web application for managing Visitors.

> [!NOTE]
> Looking for more information on using SAP Fiori tools? See the tutorial [SAP Fiori Tools](https://help.sap.com/docs/SAP_FIORI_tools).

## Fine-Tune the User Interface

To adapt the generated user interface to your needs, you can either use the [SAP Fiori tools, application modeler](https://help.sap.com/docs/SAP_FIORI_tools/17d50220bcd848aa854c9c182d65b699/a9c004397af5461fbf765419fc1d606a.html?locale=en-US) or you can change the generated files manually.

The SAP Fiori tools - Application Modeler includes two tools that help you create new pages or adjusting existing ones:

- [Page Editor](https://help.sap.com/docs/SAP_FIORI_tools/17d50220bcd848aa854c9c182d65b699/047507c86afa4e96bb3d284adb9f4726.html?locale=en-US): Create and maintain annotation-based UI elements.
- [Page Map](https://help.sap.com/docs/SAP_FIORI_tools/17d50220bcd848aa854c9c182d65b699/bae38e6216754a76896b926a3d6ac3a9.html?locale=en-US): Change the structure of pages and application-wide settings.

> [!NOTE]
> The recommendation is to use SAP Fiori tools to create new pages or to enhance existing ones with additional features. These tools generate the required annotations in the annotations file. For better readability, you can restructure the annotations afterward.

> [!WARNING]
> If annotations are added using **SAP Fiori tools – Application Modeler**, any annotations maintained in the **metadata extension** will be overwritten.

This tutorial doesn't cover a line-by-line explanation of the files. However, you can explore each file in detail to gain a deeper understanding of the sample implementation. The most relevant files are the following:

- [manifest.json](../fiori-apps/musicfestivals/webapp/manifest.json): Describes the application structure, routing, services, dependencies, and SAP Fiori launchpad integration. The crossNavigation section must be defined to enable intent-based navigation, allowing the app to be launched using a specified semantic object and action.
- [annotation.xml](../fiori-apps/musicfestivals/webapp/annotations/annotation.xml): Defines UI-specific annotations that dictate how data is displayed and behaves in the SAP Fiori application.
- [Internationalization(i18n)](../fiori-apps/musicfestivals/webapp/i18n/i18n.properties): Configures the alignment with specific requirements.
