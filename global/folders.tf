module "common" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.2"

  parent = "organizations/${var.org_id}"
  names = [
    "Common",
  ]
}

module "envs" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.2"

  parent = "organizations/${var.org_id}"
  names = [
    "Production",
    "Non-Production",
    "Development",
  ]
}
