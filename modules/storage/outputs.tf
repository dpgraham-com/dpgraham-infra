output "storage_bucket_name" {
  description = "The name of the Google Cloud bucket. has a UUID appended to the name passed in to ensure uniqueness"
  value       = google_storage_bucket.default.name
}

output "bucket_url" {
  description = "The Cloud Storage URL of the content bucket"
  value       = google_storage_bucket.default.url
}

output "resume_gs_url" {
  description = "The Google Cloud Storage URL of the resume object"
  value       = "${google_storage_bucket.default.url}/${google_storage_bucket_object.resume.name}"
}

output "resume_http_url" {
  description = "The HTTP URL of the resume object"
  value       = google_storage_bucket_object.resume.media_link
}