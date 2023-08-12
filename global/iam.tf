module "folders-iam-0-computeinstanceAdminv1" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.envs.ids["Non-Production"],
  ]
  bindings = {
    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

module "folders-iam-0-containeradmin" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.envs.ids["Non-Production"],
  ]
  bindings = {
    "roles/container.admin" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

module "folders-iam-1-computeinstanceAdminv1" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.envs.ids["Development"],
  ]
  bindings = {
    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

module "folders-iam-1-containeradmin" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.envs.ids["Development"],
  ]
  bindings = {
    "roles/container.admin" = [
      "group:gcp-developers@dpgraham.com",
    ]
  }
}

module "projects-iam-2-loggingviewer" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.4"

  projects = [
    module.logging-km289-xm965.project_id,
  ]
  bindings = {
    "roles/logging.viewer" = [
      "group:gcp-logging-viewers@dpgraham.com",
    ]
  }
}

module "projects-iam-2-loggingprivateLogViewer" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.4"

  projects = [
    module.logging-km289-xm965.project_id,
  ]
  bindings = {
    "roles/logging.privateLogViewer" = [
      "group:gcp-logging-viewers@dpgraham.com",
    ]
  }
}

module "projects-iam-2-bigquerydataViewer" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.4"

  projects = [
    module.logging-km289-xm965.project_id,
  ]
  bindings = {
    "roles/bigquery.dataViewer" = [
      "group:gcp-logging-viewers@dpgraham.com",
    ]
  }
}

module "projects-iam-3-bigquerydataViewer" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.4"

  projects = [
    module.logging-km289-xm965.project_id,
  ]
  bindings = {
    "roles/bigquery.dataViewer" = [
      "group:gcp-security-admins@dpgraham.com",
    ]
  }
}
