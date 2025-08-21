# Deploy and Run the Application

This tutorial offers a step-by-step guide on developing and deploying the Music Festival Manager. Initially, you set it up as a multitenancy solution. Later, you enhance it with SAP S/4HANA Cloud integration and additional features.

If you prefer a quick start without further explanation and want to the application with all features, follow these steps:

1. [Prepare your SAP BTP provider account, SAP Business Application Studio (BAS) and ABAP Development Tools (ADT) for development](./11-Prepare-BTP-Account-ADT-For-Dev.md).
2. [Enable the entitlements mentioned in the bill of materials of the multi-tenant application](./60-BillOfMaterials.md).
3. Create the software component in the SAP BTP ABAP environment by following the steps outlined in the [Software Component Creation](./12-Develop-BTP-ABAP-RAP-Application.md#software-component-creation) section.
4. After creating the software component, you create an ABAP Cloud project in Eclipse. Then, you onboard the software component in Eclipse ADT.

    > **Note**: To create an ABAP Cloud project, follow the [Create ABAP Cloud Project](https://developers.sap.com/tutorials/abap-environment-create-abap-cloud-project.html) tutorial.
    > Once done, you include the software component into the project. Right-click on your project and choose **Add package**. Select the software component created above, for example ZPRA_MUSIC_FESTIVAL_MGR. The software component is present in your local system in ADT.

5. [Import the Music Festival Manager application from your abapGit repository into your ABAP environment in ADT](https://help.sap.com/docs/btp/sap-business-technology-platform/import-content-from-abapgit-repository-into-abap-environment).

    - **GitHub URL** - **https://github.com/SAP-samples/abap-partner-reference-application**
    - **Branch** - *main*

6. Pull the repository by right-clicking on the `ZPRA_MUSIC_FESTIVAL_MGR` package name under the abapGit repositories window and choose **Pull**.

    <img src="./images/02_abapgit.png" width="30%"/> 

    > **Note**: The pull operation doesn't succeed initially because the SAP Fiori application hasn't been deployed yet. Consequently, the ABAP objects related to the SAP Fiori application aren't pulled. 

7. Choose **Activate inactive ABAP development objects** to activate all the objects that are pulled from the Git repository.

    > **Note:**
    > - The activation process may fail for some objects due to dependencies or missing components.
    > - Follow the sequence below to ensure a successful activation of the objects:

    **Activation Sequence:**
    1. **Activate Dictionary Objects**: Start by activating all dictionary objects. These include:
        - Data elements
        - Domains
        - Database tables
    2. **Activate Source Code Libraries**: Proceed to activate all source code libraries, such as classes.
    3. **Activate Remaining Objects (Excluding Specific Ones)**:
        - Activate all objects except the following:
            - `ZPRA_MF_MusicFestival`
            - `ZPRA_MF_Visitor`
            - `ZPRA_MF_UI_MUSICFESTIVAL_O4`
            - `ZPRA_MF_UI_VISITOR_O4`
            - `ZPRA_MF_LST`
    4. **Activate All Except `ZPRA_MF_LST`**: Activate all remaining objects except `ZPRA_MF_LST`.

    > **Note:** Ensure that all ABAP objects, except `ZPRA_MF_LST`, are activated successfully before proceeding to the next step.

8. Now, let's deploy the **Music Festival Manager** and **Visitors** SAP Fiori applications.

    1. Open SAP BAS and clone the [ABAP Partner Reference Application](https://github.com/SAP-samples/abap-partner-reference-application) repository.

        > **Note:** If SAP BAS is not yet enabled, follow the steps to [enable SAP BAS](./11-Prepare-BTP-Account-ADT-For-Dev.md#enable-sap-business-application-studio) before proceeding with SAP Fiori application development.

    2. Open the terminal in the **abap-partner-reference-application** folder and run `cd fiori-apps/`.
    3. Replace the content below with your own:

        i. **Service URL** - Search for *<ABAP_SERVICE_URL>* and replace it with your ABAP service URL.

        ii. **Destination** - Search for *<DESTINATION_NAME>* and replace it with your destination name to connect to your ABAP service.

        iii. **Transport Request Number** - Update the transport number in the **ui5-deploy.yaml** file for both the Music Festival Manager and the Visitors applications.

        iv. **Authentication Type** - The `reentranceTicket` authentication type is mandatory when your SAP BAS and SAP BTP ABAP environment instances are in different SAP BTP subaccounts. If both instances are in the same SAP BTP subaccount, you can comment out this setting because it isn't required.

    **Steps to Deploy the Music Festival Application:**
    1. Navigate to the `musicfestivals` folder.
    2. Run the following commands in sequence:
        - `npm run install` - Installs the required dependencies for the application.
        - `npm run build` - Builds the application, preparing it for deployment.
        - `npm run deploy` - Deploys the application to the SAP BTP ABAP environment.

    **Steps to Deploy the Visitors Application:**
    1. Navigate to the `visitors` folder.
    2. Run the following commands in sequence:
        - `npm run install` - Installs the required dependencies for the application.
        - `npm run build` - Builds the application, preparing it for deployment.
        - `npm run deploy` - Deploys the application to the SAP BTP ABAP environment.

    > **Notes:**
    > - If the deployment fails on the first attempt, try to retrigger the deployment to resolve any transient issues.
    > - If the deployment of UI applications from BAS fails with an error indicating that the packages ZPRA_MF_UI_MNG_MUSIC_FESTS and ZPRA_MF_UI_MNG_VISITORS are not available, manually create these two packages in ADT and then try deploying again.
    > - If you encounter an error stating "duplicate ID in SAP UI5 repository" during deployment, open your manifest.json file and update the id field under the "sap.app" section to a unique value. Then, try deploying again.
    > - Ensure that the deployment processes for both applications complete successfully before proceeding to the next steps.

9. After successfully deploying the SAP Fiori applications, return to the abapGit repositories window in ADT and perform the pull operation again to fetch the remaining ABAP objects related to SAP Fiori applications.

    - Right-click on the `ZPRA_MUSIC_FESTIVAL_MGR` package name under the abapGit repositories window and choose **Pull**.

    > **Notes:**
    > - During the pull operation, verify and keep the following objects **unchecked**:
    >   - `ZPRA_MF_MF_UI5R`
    >   - `ZPRA_MF_VSTR_UI5R`
    >   - `ZPRA_MF_UI_MUSICFESTIVAL__00001_IBS`
    >   - `ZPRA_MF_UI_VISITOR_O4_0001_G4BA_IBS`
    >   
    >   These objects are already created during the deployment of the SAP Fiori applications and don't need to be pulled again.
    > - Verify that all remaining objects are successfully pulled into the ABAP environment.

10. Once the pull operation is complete, activate all the newly pulled objects.

    > **Note:** Ensure that all objects are activated without errors before proceeding to the next steps.

11. Follow the steps below to publish the business role templates in ADT to enable the necessary roles for the application:

    1. Open the ADT in Eclipse.
    2. Use the search functionality to locate the following business role templates:
        - `ZPRA_MF_DISP_BRT`
        - `ZPRA_MF_UPD_BRT`
    3. Select each role template and choose **Publish Locally**.

    > **Note:**
    > - To quickly find an ABAP object in ADT, use the shortcut:
    >   - *Windows*: `Ctrl + Shift + A`
    >   - *Mac*: `Cmd + Shift + A`

12. Scope in the launchpad page and space templates to enable navigation and role-based access.

    1. Open the ADT in Eclipse.
    2. Use the search functionality to locate the following class:
        - `ZCL_PRA_MF_SCOPE_PG_SP_TMPLT`
    3. Right-click on the class and select **Run As > ABAP Application (Console)** to execute the scoping process.

13. [Create the business roles and assign the business users in the ABAP landscape](./22-Integration%20Application%20into%20Launchpad.md#creating-business-roles-and-assigning-business-users)
14. To integrate your SAP BTP application with the SAP S/4HANA Cloud Public Edition, follow the steps outlined in this guide: [Integration with SAP S/4HANA Cloud Public Edition](./40_Integration-with-S4-Public-Cloud.md).

You've successfully deployed your SAP Fiori applications.
