# modules/sql/output.tf
# outputs for the Google cloud SQL module

output "db_user" {
  value     = google_sql_user.user.name
  sensitive = true
}

output "db_password" {
  value     = google_sql_user.user.password
  sensitive = true
}