# Changes

## Current Version - April 2026

The tutorials and sample application code are available in the main branch.

The current version includes:

- [Business Event Logging Feature](./Tutorials/43-Business-Event-Logging-Feature.md): Trigger events for various scenarios, such as creating, updating, or deleting a music festival event and monitor it in Business Event Logging (BEL) apps.
- [Print Service](./Tutorials/41b-Print-Documents.md): Print guest list documents for music festival events using SAP Forms service by Adobe.
- [Custom Tile in SAP S/4HANA Cloud Public Edition Launchpad](./Tutorials/40a-Add-BTP-App-into-S4-Public-Cloud-Launchpad.md): Add SAP BTP ABAP applications as custom tiles in the SAP S/4HANA Cloud Public Edition launchpad.
- Clean Code: Comprehensive clean code refactoring across the codebase following [SAP Clean ABAP guidelines](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md).
- [Data Element Type Change](./objects/DTEL/ZPRA_MF_NAME): The `ZPRA_MF_NAME` data element type has been changed from `STRING(256)` to `CHAR(255)` for better compatibility with database operations and OData services.
> **Note**: For detailed guidance on the adoption kindly follow [Troubleshoot Guide](./Tutorials/93-Troubleshooting-Guide.md).

## Version - February 2026

The tutorials and sample application code are available in the main branch.

The current version includes:

- [ABAP AI](./Tutorials/42-Consuming-ISLM-for-GenAI.md): Event creation with a title and description based on user-provided tags, optional rhymes, and the target language.
- [Adobe Forms](./Tutorials/41a-Forms-Feature.md): Generate PDF file of a music festival event containing all event data using Adobe Forms service.
- Authentication Method Change: Communication from ABAP PRA to SAP S/4HANA Cloud Public Edition is changed from basic authentication to OAuth Client Credentials.
- SSO Support: The front-end navigation from the Music Festival App to SAP S/4HANA Cloud Public Enterprise Project now supports SSO.
- Other tutorials :
    - [Message Handling](./Tutorials/91-Message-Handling.md)
    - [Bill Of Materials](./Tutorials/00-BillOfMaterials.md)
  
- Tag: release-2602
  
## August 2025 (Initial Version)

The tutorials and sample reference application code are available in the main branch.

### Highlights

- Comprehensive step-by-step tutorials for building, deploying, and integrating a multi-tenant SaaS solution using SAP BTP ABAP Environment.
- Ready-to-run sample code for the Music Festival Manager application.
- Guidance on best practices for ABAP RAP, Fiori Elements, and SAP S/4HANA Cloud integration.

### Tutorials Provided

1. Developing a side-by-side RAP application in SAP BTP ABAP Environment.
2. Building a Fiori-based web application for the RAP application.
3. Setting up authentication and role-based authorization.
4. Enabling multitenancy, and managing deployment, provisioning, and commercializing the SaaS solution for the RAP application.
5. Integrating the side-by-side RAP application with SAP S/4HANA Cloud Public Edition.

### Additional Notes

- All tutorials are located in the [Tutorials](Tutorials/) directory.
- Refer to the [README.md](README.md) for an overview and navigation help.
- For deployment instructions, see [deploy/README.md](deploy/README.md).

- Tag: [release-2508](https://github.com/SAP-samples/abap-partner-reference-application/releases/tag/release-2508)