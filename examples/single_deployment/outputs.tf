output "folders" {
  description = "Folder ids"
  value       = module.migration-folders.ids
}

output "core_project_id" {
  description = "Project id of the core project"
  value       = module.core-project.project_id
}

output "velos_network_name" {
  description = "Name of the VPC created"
  value       = module.velos-single-project.network_name
}

output "velos_migration_manager_svc" {
  description = "Name of the VPC created"
  value       = module.velos-single-project.velos_migration_manager_svc
}

output "velos_compute_engine_cloud_extension_svc" {
  description = "Name of the VPC created"
  value       = module.velos-single-project.velos_compute_engine_cloud_extension_svc
}
