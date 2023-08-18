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

output "db_name" {
  value = google_sql_database_instance.default.name
}

output "db_host" {
  value = google_sql_database_instance.default.private_ip_address
}