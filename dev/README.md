# DEV

This is the development environment cloud infrastructure configs. it's intended to
be used for the dpgraham.com organization.

## Prerequisites

A service account defined through the dpgraham.com organization (through the org admin) which will be used with
terraform. The service account, if this is set up correctly, should be capable of creating all resources in this
directory.

The service account should have the following roles:

- "roles/iam.workloadIdentityUser"
    - so the service account can use Workload Identity Federation instead of using a long-lived key file which
      represents a security risk
- Whatever roles are necessary to provision the resources defined in this directory.
    - I know that's broad, but I'm not maintaining a list right here, look at the configs.

## Usage

Be sure to add the service account information to the GitHub environment secrets for the repository.

- `WIF_PROVIDER` - the fully qualified ID of the workload identity federation provider
- `SA_EMAIL` - the email address of the service account

Changes to the infrastructure **should** be made through changes to the git repository (triggering the GitHub action
workflow).

## Resources and Organization

The resources defined through this configs should be germaine to running the development environment application.
Things such as k8 clusters, cloud run services, Cloud SQL services, etc. should be defined here.

We keep things related to authentication and authorization in the `global` directory configs (i.e., the service account
definition, Workload Identity Federation pools, etc.). This way the service account we use to, for example, provision
resources in the development environment cannot delete itself. The downside is that if a project needs additional
permissions, we have to "ask" the org admin. 

