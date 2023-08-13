# outputs for the cloud sql instance and related resources

output "db_name" {
  value = google_sql_database.postgres.name
}

output "db_user" {
  value     = google_sql_user.user.name
  sensitive = true
}

output "db_password" {
  value     = google_sql_user.user.password
  sensitive = true
}

output "db_host" {
  value = google_sql_database_instance.database_instance.private_ip_address
}

output "vpc_connector" {
  value = google_service_networking_connection.sql_vpc_connection.id
}