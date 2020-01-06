/**
 * Copyright 2019 Google LLC
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

variable "project_id" {
  description = "Project where the VM velostrata manager is deployed"
}

variable "subnet_name" {
  description = "Subnet where the VM velostrata manager is deployed"
}
variable "subnet_project" {
  description = "Subnet project for the subnet where the VM velostrata manager is deployed"
}

variable "cloud_extension_svc_email" {
  description = "Email of the cloud extension service account"
}

variable "velos_manager_svc_email" {
  description = "Email of the cvelos manager service account"
}

variable "velostrata_vm_name" {
  description = "Name for the VM velostrata manager is deployed"
  default     = "velostrata-tf-vm"
}

variable "velostrata_vm_zone" {
  description = "Zone for the VM velostrata manager is deployed in"
}

variable "velostrata_vm_machine_type" {
  description = "Machine Type for velostrata manager VM"
  default     = "n1-standard-4"
}

variable "velostrata_vm_tags" {
  description = "Tags for velostrata vm. fw-velosmanager is added automatically"
  default     = []
}

variable "velostrata_vm_password" {
  description = "Password to login for Velostrata Frontend"
}

variable "velostrata_vm_encryption_key" {
  description = "Encryption key for Velostrata Frontend"
}
