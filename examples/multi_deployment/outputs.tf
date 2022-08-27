/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "folders" {
  description = "Folder ids"
  value       = module.migration-folders.ids
}

output "shared_vpc_project_id" {
  value       = module.velos-multi-project.shared_vpc_project_id
  description = "The ID of the shared VPC host project"
}

output "velos_project_id" {
  value       = module.velos-multi-project.velos_project_id
  description = "The ID of the velo project"
}

output "prod_project_id" {
  value       = module.velos-multi-project.prod_project_id
  description = "The ID of the prod project"
}

output "non_prod_project_id" {
  value       = module.velos-multi-project.non_prod_project_id
  description = "The ID of the stage project"
}

output "velos_network_name" {
  description = "Name of the VPC created"
  value       = module.velos-multi-project.network_name
}

output "velos_migration_manager_svc" {
  description = "Velostrata migration service account"
  value       = module.velos-multi-project.velos_migration_manager_svc
}

output "velos_compute_engine_cloud_extension_svc" {
  description = "Velostrata cloud extension service account"
  value       = module.velos-multi-project.velos_compute_engine_cloud_extension_svc
}

output "vpc_tunnel_name" {
  description = "The VPN tunnel name is"
  value       = module.velos-vpn.vpn_tunnels_names-dynamic
}

output "gateway_ip" {
  description = "The VPN Gateway Public IP"
  value       = module.velos-vpn.gateway_ip
}

output "velos_vm_ui" {
  value       = module.velos-multi-project.velos_vm_ui
  description = "URL for Velostrata Manger"
}

output "velos_manager_username" {
  value       = "apiuser"
  description = "Username for Velostrata Manger"
}

output "velos_manager_password" {
  value       = module.velos-multi-project.velos_manager_password
  sensitive   = true
  description = "Username for Velostrata Manger"
}
