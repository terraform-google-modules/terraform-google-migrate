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

output "velos_vm_ui" {
  value       = "https://${google_compute_address.velo-frontend-ip.address}"
  description = "URL for Velostrata Manger"
}

output "velos_manager_username" {
  value       = "apiuser"
  description = "Username for Velostrata Manger"
}

output "velos_manager_password" {
  value       = var.velostrata_vm_password
  sensitive   = true
  description = "Password for Velostrata Manger"
}

output "velos_manager_instance_id" {
  value       = google_compute_instance.velo-vm.instance_id
  description = "Instance ID for Velostrata Manger VM"
}
