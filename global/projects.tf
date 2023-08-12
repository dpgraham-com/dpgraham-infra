module "vpc-host-prod-km289-xm965" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "vpc-host-prod"
  project_id = "vpc-host-prod-km289-xm965"
  org_id     = var.org_id
  folder_id  = module.common.id

  billing_account                = var.billing_account
  enable_shared_vpc_host_project = true
}

module "vpc-host-nonprod-km289-xm965" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "vpc-host-nonprod"
  project_id = "vpc-host-nonprod-km289-xm965"
  org_id     = var.org_id
  folder_id  = module.common.id

  billing_account                = var.billing_account
  enable_shared_vpc_host_project = true
}

module "logging-km289-xm965" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "logging"
  project_id = "logging-km289-xm965"
  org_id     = var.org_id
  folder_id  = module.common.id

  billing_account = var.billing_account
}

module "monitoring-prod-km289-xm965" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "monitoring-prod"
  project_id = "monitoring-prod-km289-xm965"
  org_id     = var.org_id
  folder_id  = module.common.id

  billing_account = var.billing_account
}

module "monitoring-nonprod-km289-xm965" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "monitoring-nonprod"
  project_id = "monitoring-nonprod-km289-xm965"
  org_id     = var.org_id
  folder_id  = module.common.id

  billing_account = var.billing_account
}

module "monitoring-dev-km289-xm965" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "monitoring-dev"
  project_id = "monitoring-dev-km289-xm965"
  org_id     = var.org_id
  folder_id  = module.common.id

  billing_account = var.billing_account
}

module "dpgraham-com-prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "dpgraham-prod"
  project_id = "dpgraham-com-prod"
  org_id     = var.org_id
  folder_id  = module.envs.ids["Production"]

  billing_account = var.billing_account
}

module "dpgraham-com-dev" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "dpgraham-dev"
  project_id = "dpgraham-com-dev"
  org_id     = var.org_id
  folder_id  = module.envs.ids["Development"]

  billing_account = var.billing_account
}
