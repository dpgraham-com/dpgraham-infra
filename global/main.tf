module "folders" {
  source = "./folders"
  org_id = var.org_id
}

module "iam" {
  source = "./iam"

}