output "storage_bucket_name" {
  value = google_storage_bucket.default.name
}

output "bucket_url" {
  value = google_storage_bucket.default.url
}

output "resume_url" {
  value = "${google_storage_bucket.default.url}/${google_storage_bucket_object.resume.name}"
}