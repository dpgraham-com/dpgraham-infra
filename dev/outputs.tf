output "bucket_name" {
  description = "The name of the bucket used for the website's assets, documents, and my resume"
  value       = module.storage.storage_bucket_name
}

output "bucket_url" {
  description = "The URL of the bucket used for the website's assets, documents, and my resume"
  value       = module.storage.bucket_url
}

output "resume_url" {
  description = "The URL of my resume object for use with the gsutil command"
  value       = module.storage.resume_url
}

