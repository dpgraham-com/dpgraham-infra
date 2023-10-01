# iam.tf creates the global IAM policies for the organization
# It was initially generated by the GCP organization setup tool
# resource names follow a convention of <principal>-<resource>-<optional description>
# for example, for a given principal (usually a group), we assign a list of roles for a given resource


# We use the terraform-google-modules GitHub organization, specifically the iam repo and its TF modules
# they expose modules to declare IAM policies for organizations, folders, projects, etc.
# https://github.com/terraform-google-modules/terraform-google-iam
# Just remember that roles are inherited, if we assign a role to a folder,
# it will be inherited by all projects and resources under that folder

# Not all polices are managed by terraform, such as billing account permissions and organization ownership
# These are managed manually to ensure that we don't accidentally remove them with `terraform destroy`

resource "google_service_account" "cloud_infra_sa_dev" {
  project      = module.dpgraham-com-dev.project_id
  account_id   = "${var.cloud_infra_sa}-dev"
  display_name = "Cloud Infra Service Account for dev environment"
  description  = "Service account used by automation to provision cloud resources"
}

resource "google_service_account" "cloud_infra_sa_prod" {
  project      = module.dpgraham-com-prod.project_id
  account_id   = "${var.cloud_infra_sa}-prod"
  display_name = "Cloud Infra Service Account for prod environment"
  description  = "Service account used by automation to provision cloud resources"
}


module "developer-folder-nonprod" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.folders.ids["Non-Production"],
  ]
  bindings = {
    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@dpgraham.com",
    ]
    "roles/container.admin" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

module "developers-folders-dev" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.folders.ids["Development"],
  ]
  bindings = {
    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@dpgraham.com",
    ]
    "roles/container.admin" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

# required policies to allow us to create shared VPC connectors in the service project
# https://cloud.google.com/functions/docs/networking/shared-vpc-service-projects#grant-permissions
module "service_accounts_nonprod_shared_vpc_connectors" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.dev_shared_vpc_project_id]
  version  = "~> 7.4"
  bindings = {
    "roles/compute.networkUser" = [
      "serviceAccount:service-${var.dpgraham_dev_project_number}@gcp-sa-vpcaccess.iam.gserviceaccount.com",
      "serviceAccount:${var.dpgraham_dev_project_number}@cloudservices.gserviceaccount.com",
      "serviceAccount:${google_service_account.cloud_infra_sa_dev.email}",
    ]
  }
}

module "service_accounts_prod_shared_vpc_connectors" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [module.vpc-prod-shared.project_id]
  version  = "~> 7.4"
  bindings = {
    "roles/compute.networkUser" = [
      "serviceAccount:service-${module.dpgraham-com-prod.project_number}@gcp-sa-vpcaccess.iam.gserviceaccount.com",
      "serviceAccount:${module.dpgraham-com-prod.project_number}@cloudservices.gserviceaccount.com",
      "serviceAccount:${google_service_account.cloud_infra_sa_prod.email}",
    ]
  }
  depends_on = [
    module.vpc-prod-shared,
    google_service_account.cloud_infra_sa_prod
  ]
}

module "devops-folder-dev" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.folders.ids["Development"],
  ]
  bindings = {
    "roles/cloudsql.admin" = [
      "group:gcp-devops@${var.primary_domain}",
      "serviceAccount:${google_service_account.cloud_infra_sa_dev.email}",
    ]
    "roles/editor" = [
      "group:gcp-devops@${var.primary_domain}",
      "serviceAccount:${google_service_account.cloud_infra_sa_dev.email}",
    ]
    "roles/run.developer" = [
      "group:gcp-devops@${var.primary_domain}",
    ]
    "roles/compute.networkAdmin" = [
      "serviceAccount:${google_service_account.cloud_infra_sa_dev.email}",
    ]
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${google_service_account.cloud_infra_sa_dev.email}",
    ]
  }
}


module "devops-folder-prod" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.folders.ids["Production"],
  ]
  bindings = {
    "roles/cloudsql.admin" = [
      "group:gcp-devops@${var.primary_domain}",
      "serviceAccount:${google_service_account.cloud_infra_sa_prod.email}",
    ]
    "roles/editor" = [
      "group:gcp-devops@${var.primary_domain}",
      "serviceAccount:${google_service_account.cloud_infra_sa_prod.email}",
    ]
    "roles/run.developer" = [
      "group:gcp-devops@${var.primary_domain}",
    ]
    "roles/compute.networkAdmin" = [
      "serviceAccount:${google_service_account.cloud_infra_sa_prod.email}",
    ]
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${google_service_account.cloud_infra_sa_prod.email}",
    ]
  }
  depends_on = [
    google_service_account.cloud_infra_sa_prod
  ]
}


module "gh_oidc_dev" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "3.1.1"

  project_id       = module.dpgraham-com-dev.project_id
  pool_id          = var.pool_id
  provider_id      = "github"
  pool_description = "A pool of identities to be used by GitHub Actions workflow runners"
  sa_mapping       = {
    "cloud_run_service_account" = {
      sa_name   = google_service_account.cloud_infra_sa_dev.name
      attribute = "attribute.repository/${var.github_org}/dpgraham-client"
    }
    "infra_editor_service_account" = {
      sa_name   = google_service_account.cloud_infra_sa_dev.name
      attribute = "attribute.repository/${var.github_org}/dpgraham-infra"
    }
  }
}

module "gh_oidc_prod" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "3.1.1"

  project_id       = module.dpgraham-com-prod.project_id
  pool_id          = var.pool_id
  provider_id      = "github"
  pool_description = "A pool of identities to be used by GitHub Actions workflow runners"
  sa_mapping       = {
    "cloud_run_service_account" = {
      sa_name   = google_service_account.cloud_infra_sa_prod.name
      attribute = "attribute.repository/${var.github_org}/dpgraham-client"
    }
    "infra_editor_service_account" = {
      sa_name   = google_service_account.cloud_infra_sa_prod.name
      attribute = "attribute.repository/${var.github_org}/dpgraham-infra"
    }
  }
}


## IAM permissions related to the logging project

#module "projects-iam-2-loggingviewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/logging.viewer" = [
#      "group:gcp-logging-viewers@dpgraham.com",
#    ]
#  }
#}
#
#module "projects-iam-2-loggingprivateLogViewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/logging.privateLogViewer" = [
#      "group:gcp-logging-viewers@dpgraham.com",
#    ]
#  }
#}
#
#module "projects-iam-2-bigquerydataViewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/bigquery.dataViewer" = [
#      "group:gcp-logging-viewers@dpgraham.com",
#    ]
#  }
#}
#
#module "projects-iam-3-bigquerydataViewer" {
#  source  = "terraform-google-modules/iam/google//modules/projects_iam"
#  version = "~> 7.4"
#
#  projects = [
#    module.dpgraham-logging.project_id,
#  ]
#  bindings = {
#    "roles/bigquery.dataViewer" = [
#      "group:gcp-security-admins@dpgraham.com",
#    ]
#  }
#}
