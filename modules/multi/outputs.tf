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

output "shared_vpc_project_id" {
  value       = module.vpc-project.project_id
  description = "The ID of the shared vpc project"
}

output "velos_project_id" {
  value       = module.velo-project.project_id
  description = "The ID of the velo project"
}

output "prod_project_id" {
  value       = module.prod-project.project_id
  description = "The ID of the prod project"
}

output "non_prod_project_id" {
  value       = module.nonprod-project.project_id
  description = "The ID of the nonpod project"
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "velos_migration_manager_svc" {
  value       = google_service_account.velos-manager.email
  description = "Service account for Manager Service"
}

output "velos_compute_engine_cloud_extension_svc" {
  value       = google_service_account.velos-cloud-extension.email
  description = "Service account for Compute Engine Cloud Extension"
}

output "velos_vm_ui" {
  value       = module.velos-manager-vm.velos_vm_ui
  description = "URL for Velostrata Manger"
}

output "velos_manager_username" {
  value       = module.velos-manager-vm.velos_manager_username
  description = "Username for Velostrata Manger"
}

output "velos_manager_password" {
  value       = module.velos-manager-vm.velos_manager_password
  sensitive   = true
  description = "Password for Velostrata Manger"
}
