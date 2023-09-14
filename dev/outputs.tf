output "bucket_name" {
  description = "The name of the bucket used for the website's assets, documents, and my resume"
  value       = module.storage.storage_bucket_name
}

output "bucket_url" {
  description = "The URL of the bucket used for the website's assets, documents, and my resume"
  value       = module.storage.bucket_url
}

output "resume_gs_url" {
  description = "The Google Cloud Storage URL of the resume object for use with the gsutil command"
  value       = module.storage.resume_gs_url
}

output "resume_http_url" {
  description = "The media link HTTP URL of the resume PDF object"
  value       = module.storage.resume_http_url
}

