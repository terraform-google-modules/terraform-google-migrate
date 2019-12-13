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
  default     = "multi-dep"
}

variable "vpc_project_name" {
  description = "Shared VPC GCP Project Name"
  default     = "shared-vpc-proj"
}

variable "velo_project_name" {
  description = "Velostrata GCP Project Name"
  default     = "velostrata-proj"
}

variable "prod_project_name" {
  description = "Production GCP Project Name"
  default     = "prod-proj"
}

variable "nonprod_project_name" {
  description = "Nonprod GCP Project Name"
  default     = "nonprod-proj"
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
