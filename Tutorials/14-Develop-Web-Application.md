# Building a Fiori-Based Web Application using ABAP RAP

You’ve built and exposed the OData service in ABAP RAP. In this tutorial, you're creating a SAP Fiori UI for the Music Festivals OData service to efficiently manage music festival events.

## Prerequisites

1. **SAP Business Application Studio (SAP BAS) is enabled**: Ensure SAP BAS is activated, and a Dev space is created for your development. For setup instructions, refer to [Enable SAP Business Application Studio](./11-Prepare-BTP-Account-ADT-For-Dev.md#enable-sap-business-application-studio).
2. **Creating a service key for the ABAP system**: A service key is required for establishing a secure connection between SAP BAS and the ABAP system. You can create the service key through your BTP subaccount. For detailed instructions, refer to [Creating a Service Key for ABAP System](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-service-key-for-abap-system).
3. **Destination to ABAP system for SAP BAS is set up**: A destination to the ABAP system must be configured in your SAP BTP subaccount. If SAP BAS and ABAP environment are in the same subaccount, follow [Creating a Destination to the ABAP System for SAP Business Application Studio](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-destination-to-abap-system-for-sap-business-application-studio). For different subaccounts, configure cross-subaccount communication by following [Creating a Destination for Cross-Subaccount Communication](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-destination-for-cross-subaccount-communication) and [Creating a Communication System for SAP Business Application Studio](https://help.sap.com/docs/btp/sap-business-technology-platform/creating-communication-system-for-sap-business-application-studio).

## Add a Web Application with SAP Fiori Elements

1. Open your Dev space in SAP BAS:

   1. In SAP BAS, open the menu on the left and choose **File > Open Folder** to set your workspace.
   2. Navigate to */home/user/projects/* and choose **OK**.

2. Set up the Cloud Foundry organization and space:

   1. Choose **Settings** in SAP BAS and open the **Command Palette**.
   2. Search for *CF: Login to Cloud Foundry* and select it.
   3. Paste your **Cloud Foundry API endpoint**, enter your credentials, and choose **Sign In**.
   4. After logging in, set your Cloud Foundry target:
      * **Cloud Foundry Organization**: *Enter the org name*
      * **Cloud Foundry Space**: *Enter the space*

   > Note: You can find the Cloud Foundry API endpoint, organization name, and space on the **Overview** tab of your subaccount in the **SAP BTP cockpit**.

3. Select a template:
   
   1. Ensure that the target folder path is set to */home/user/projects*.
   2. Go to **Settings** in SAP BAS and open the **Command Palette**.
   3. Search for *Fiori: Open Application Generator* and select it.
   4. Choose **List Report Page** and then **Next**.

4. Enter the data source and select a service:

      * **Data source**: *Connect to a System*
      * **System**: *Enter the destination name*
      * **Service**: *Enter the service name*.
        
   Choose **Next**.

5. Select the entity:

      * **Main Entity**: *MusicFestival*
      * **Navigation Entity**: *_Visits*
      * **Automatically add table columns to the list page and a section to the object page if none already exists?**: *Yes*
      * **Table Type**: *Responsive*

6. Enter the project attributes:

      * **Module Name**: *musicfestivals*
      * **Application Title**: *Music Festival Manager*
      * **Description**: *A Music Festival Manager application.*
      * **Project Folder Path**: */home/user/projects*
      * **Enable TypeScript**: *No*
      * **Add Deployment Configuration**: *Yes*
      * **Add FLP Configuration**: *Yes*
      * **Use Virtual Endpoints for Local Preview**: *Yes*
      * **Configure Advanced Options**: *No*
   
   Choose **Next**.

   > Note: The application name should start with the letter *z* and be in *lowercase letters*.

7. Enter the deployment configuration information:

      * **Please choose the target**: *ABAP*
      * **Destination**: *Enter the destination name*
      * **SAP UI5 ABAP Repository**: *ZPRA_MF_MF*
      * **How do you want to enter the package?**: *Enter manually*
      * **Package**: *ZPRA_MF_UI_MNG_MUSIC_FESTS*
      * **How do you want to enter the transport request?**: *Create new*
   
   Choose **Next**.

   > Note: To find your **transport request**, open Eclipse, search for your package, and check the *Transport Organizer*. Select the transport request of the superior folder under *Modifiable*.

8. Enter the SAP Fiori launchpad configuration:

      * **Semantic Object**: *ZPRA_MF_MF*
      * **Action**: *display*
      * **Title**: *Manage Music Festival*
   
   Choose **Finish**.

   > Note: The wizard creates the *musicfestivals* folder with all necessary UI files.

9. Preview the application:

   1. Right-click on the **musicfestivals** folder and choose **Open Application Info**.
   2. Choose **Preview Application** to view it running in a new browser tab.

10. Build and deploy the application:

      1. Navigate to the *musicfestivals* folder in your command prompt.
      2. Run the `npm run build` command to build the app.
      3. Once the build is complete, run the `npm run deploy` command to deploy the app.

      > Note: After deployment, you see the **BSP application** and the **Launchpad App Descriptor Items** under *Fiori User Interface* in your *ADT* within the *ZPRA_MF_UI_MNG_MUSIC_FESTS* package. These items are used for configuring the IAM apps.

Similarly, you can create a web application for managing Visitors.

> Note: Looking for more information on using SAP Fiori tools? See the tutorial [Serving SAP Fiori UIs](https://help.sap.com/docs/SAP_FIORI_tools).

## Fine-Tune the User Interface

To adapt the generated user interface to your needs, you can either use the [SAP Fiori tools, application modeler](https://help.sap.com/docs/SAP_FIORI_tools/17d50220bcd848aa854c9c182d65b699/a9c004397af5461fbf765419fc1d606a.html?locale=en-US) or you can change the generated files manually.

The SAP Fiori tools - Application Modeler includes two tools that help you create new pages or adjusting existing ones:

- [Page Editor](https://help.sap.com/docs/SAP_FIORI_tools/17d50220bcd848aa854c9c182d65b699/047507c86afa4e96bb3d284adb9f4726.html?locale=en-US): Create and maintain annotation-based UI elements.
- [Page Map](https://help.sap.com/docs/SAP_FIORI_tools/17d50220bcd848aa854c9c182d65b699/bae38e6216754a76896b926a3d6ac3a9.html?locale=en-US): Change the structure of pages and application-wide settings.

> Note: The recommendation is to use SAP Fiori tools to create new pages or to enhance existing ones with additional features. These tools generate the required annotations in the annotations file. For better readability, you can restructure the annotations afterward.

This tutorial doesn't cover a line-by-line explanation of the files. However, you can explore each file in detail to gain a deeper understanding of the sample implementation. The most relevant files are the following:

- [manifest.json](../fiori-apps/musicfestivals/webapp/manifest.json): Describes the application structure, routing, services, dependencies, and SAP Fiori launchpad integration. The crossNavigation section must be defined to enable intent-based navigation, allowing the app to be launched using a specified semantic object and action.
- [annotation.xml](../fiori-apps/musicfestivals/webapp/annotations/annotation.xml): Defines UI-specific annotations that dictate how data is displayed and behaves in the SAP Fiori application.
- [Internationalization(i18n)](../fiori-apps/musicfestivals/webapp/i18n/i18n.properties): Configures the alignment with specific requirements.
