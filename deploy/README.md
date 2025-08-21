# Music Festival Manager - ABAP Multi-Tenant Solution (SaaS)

> 💡 **Reference**: [ABAP SaaS reference solution for ABAP solution provider](https://github.com/sap-software/abap-saas-reference-solution)
>
> ⓘ **More Information**: See [Multitenancy - How to Build, Deploy and Provision the Application](../Tutorials/30-Multi-Tenancy-Build-Deploy-Provision.md)

This example shows you how to deploy a multi-tenant ABAP solution using the gCTS transport-based delivery option. After deploying the solution, you can clone the software component for the **Music Festival Manager** application in the provider tenant. This makes it available for consumption by the subscriber tenants.

## Prerequisites

1. You have developed and tested the **Music Festival Manager** application in your development environment.
2. You have installed the [Cloud MTA Build Tool](https://help.sap.com/docs/link-disclaimer?site=https%3A%2F%2Fsap.github.io%2Fcloud-mta-build-tool%2F) and the [Cloud Foundry CLI](https://help.sap.com/docs/link-disclaimer?site=https%3A%2F%2Fdocs.cloudfoundry.org%2Fcf-cli%2Finstall-go-cli.html).
3. You have the following entitlements in your provider BTP subaccount:

| Service                    | Technical Name           | Plan                  | Quota   |
| -------------------------- | ------------------------ | --------------------- | ------- |
| ABAP environment           | abap-canary              | standard              | NA      |
| ABAP environment           | abap                     | abap_compute_unit     | 1 units |
| ABAP environment           | abap                     | hana_compute_unit     | 2 units |
| ABAP Solution              | abap-solution            | standard              | NA      |
| Web access for ABAP Canary | abapcp-web-router-canary | default (Application) | NA      |

## Deploy and Provision the Application

### Set Up Destination ASP_CC

> **Reference**: [Destination setup guide on SAP Help Portal](https://help.sap.com/docs/btp/sap-business-technology-platform/saas-apps-order-and-provide?locale=en-US#loio195031ff8f484b51af16fe392ec2ae6e)

You need to set up an `OAuth2Password` destination ABAP Solution service to create and access ABAP service instances in the Cloud Foundry (CF) space of the provider subaccount. Start by creating a user in the SAP ID service. This user should be a technical user with the Space Developer role in the CF space where the application is deployed.

### Deploy the CF App

1. Install the approuter module dependencies:

   ```bash
   npm install --prefix router
   ```

2. Update the parameter values in the [mta extension file](./extensions/dev.mtaext.yaml) according to your requirements. Include any approuter routes for subscriber tenants if needed.
3. Build the MTA archive:

   ```bash
   mbt build
   ```

4. Deploy the MTA archive to the CF space:

   > The file name below depends on the version number in the `mta.yaml` file. Adjust it if you change the version number.
   > Make sure you're logged in to the CF space of the provider subaccount. You can confirm this by using the `cf target` command.

   ```bash
   cf deploy mta_archives/pra-mf_1.0.0.mtar -e extensions/dev.mtaext.yaml
   ```

### Subscribe to the New ABAP Application

After a successful deployment, you can subscribe to the new ABAP application in the subscriber subaccounts.

When you subscribe for the first time, the ABAP system instance is created. This process may take a few hours. Subsequent subscriptions are faster because the system is already present. Only the new tenant needs provisioning.

Once the system is successfully created, the administrator receives an email at the address specified in the corresponding parameter in the mta extension file.

In the provider subaccount:

1. Create an instance for the `Web Access for ABAP Canary` service in the provider subaccount to access the system.
2. Admin access to the ABAP system comes from a role collection named `<appname>-admin`. This collection is created automatically once the subscription is successful. Assign this role collection to your user in the provider subaccount.
3. To log in to the provider tenant as the initial Admin, select the newly created ABAP service instance. The user specified as provider-admin-email in the mta extension can perform this action.
4. Clone the required software component, for example `ZPRA_MUSIC_FESTIVAL_MGR` for Music Festival Manager using the `Manage Software Components` app.

### Set Up the Subscriber Tenant

1. In the SAP BTP subscriber subaccount, assign the admin role collection that was created during the subscription to your user. The name of role collection is `<appname>-admin`.
2. Select the subscribed application on the **Subscriptions** page. You're directed to the initial user onboarding process.
3. Choose **Onboard User**. You get a confirmation that the user is provisioned. This process can take a few minutes. You're redirected to the ABAP Fiori Launchpad afterwards.
4. Create the business role from the template for the app in the software component. Assign this new role to the user and wait for it to be activated.
5. Go to **Home** and refresh the launchpad. You should now see the app on the launchpad.

## Troubleshooting

See the [troubleshooting section](https://help.sap.com/docs/sap-btp-abap-environment/abap-environment/multitenancy-troubleshooting) on SAP Help Portal.

### Error on subscribing first tenant: No service offering found for service \"abap-canary\" and plan \"standard\"

Confirm that the technical user used in the **ASP_CC** destination is added to the CF space with the Space Developer role.
