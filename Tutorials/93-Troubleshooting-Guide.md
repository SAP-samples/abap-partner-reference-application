# Troubleshooting Guide

## Updating the Music Festival Application to 2604 release from Previous Versions

If you're upgrading from a previous version where `ZPRA_MF_NAME` was defined as `STRING`, you need to adjust the database table accordingly. This change was necessary because `STRING` fields are stored as LOB columns in SAP HANA, which don't support `CONTAINS` predicates used by OData `$filter` search operations without a fuzzy search index.

**Steps to upgrade:**

1. Delete all existing music festival and visitor records from the **Music Festivals** and **Visitors** apps to clear the active database tables.

2. Ensure no draft data exists. If any records show **Draft** status (see image below), save or discard them before you proceed.

   <img src="../Tutorials/images/93_Draft_Data_Example.png" width="600" alt="Example of draft data in Fiori app"/>

3. In ADT, open the `ZPRA_MF_NAME` data element and change the **Data Type** from `String` to `CHAR` with a length of `255`. Save and activate your changes.

4. Verify that all dependent CDS views and behavior definitions are active without errors.

> **Note**: For detailed guidance on choosing between `STRING` and `CHAR` data types, see the [Data Elements section](12-Develop-BTP-ABAP-RAP-Application.md#data-elements) in Developing BTP ABAP RAP Applications - Data Modeling and OData Service Generation.

## Updating the Music Festival Application after 2604 release

No change required for Database adoption

## Resolving the error `Cannot retrieve services. - Request failed with status code 500/403`

1. The error may occur in either of the following scenarios:

   - **During deployment**: when importing the code from GIT by following the Quickstart guide.
   - **While building the application from scratch**: when the destination is given as input in the **System** field for the **Data Source**.

2. If the error code is **500**, 
   - This typically indicates an incorrect Client Secret in the destination.
   - Update the destination with the correct Client Secret.
   - If the error persists after this update but now shows the code **403**, proceed to Step 3.

3. If the error code is **403**,
   - Add the parameter `HTML5.SetXForwardedHeaders` with value `false` in the destination.
   - Wait 3–4 hours before trying again, as the change may take time to take effect.
