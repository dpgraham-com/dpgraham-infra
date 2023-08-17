# Terraform Google Cloud API Module

This Terraform module enables specified Google Cloud APIs for a given project.

## Usage

```hcl
module "enable_apis" {
  source          = "./terraform-google-cloud-api-module"
  project_id      = "your-project-id"
  credentials_file = "path/to/your/credentials.json"
  services        = ["service1", "service2", "service3"]
}
