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

variable "organization_id" {
  description = "The organization id for the associated services"
}

variable "billing_account" {
  description = "The ID of the billing account to associate this projects with"
}

variable "project_prefix" {
  description = "Prefix to append to all project"
  default     = "multi-"
}

variable "vpc_project_name" {
  description = "Shared VPC GCP Project Name"
  default     = "shared-network"
}

variable "velo_project_name" {
  description = "Velostrata GCP Project Name"
  default     = "shared-migrate"
}

variable "prod_project_name" {
  description = "Production GCP Project Name"
  default     = "prod-core"
}

variable "nonprod_project_name" {
  description = "Nonprod GCP Project Name"
  default     = "nonprod-core"
}
variable "vpc_folder_id" {
  description = "Shared VPC Folder ID"
}
variable "velo_folder_id" {
  description = "Velostrata Folder ID"
}

variable "prod_folder_id" {
  description = "Production Folder ID"
}

variable "nonprod_folder_id" {
  description = "Nonprod Folder ID"
}
variable "network_name" {
  description = "Name for Shared VPC network"
  default     = "velo-network"
}

variable "subnet_01_ip" {
  description = "IP range for the subnet"
  #default    = ""
}

variable "subnet_02_ip" {
  description = "IP range for the subnet"
  #default    = ""
}

variable "subnet_03_ip" {
  description = "IP range for the subnet"
  #default    = ""
}

variable "subnet_01_region" {
  description = "Region of subnet 1"
  #default    = ""
}

variable "subnet_02_region" {
  description = "Region of subnet 2"
  #default    = ""
}

variable "subnet_03_region" {
  description = "Region of subnet 3"
  #default    = ""
}

variable "local_subnet_01_ip" {
  description = "IP range of the on-prem network"
  #default    = ""
}

variable "velostrata_vm_name" {
  description = "Name for the VM velostrata manager is deployed"
  default     = "velostrata-tf-vm"
}

variable "velostrata_vm_zone" {
  description = "Zone for the VM velostrata manager is deployed in"
  default     = "us-central1-a"
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
