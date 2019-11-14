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

variable "credentials_path" {
  description = "Path to a service account credentials file with rights to run the Project Factory. If this file is absent Terraform will fall back to Application Default Credentials."
  default     = "~/.config/gcloud/application_default_credentials.json"
}

variable "default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `depriviledge`, or `keep`."
}

variable "velo_project_id" {
  description = "Velostrata GCP Project ID"
  #default    = ""
}

variable "prod_project_id" {
  description = "Production GCP Project ID"
  #default    = ""
}

variable "stage_project_id" {
  description = "Staging GCP Project ID"
  #default    = ""
}

variable "test_project_id" {
  description = "Test GCP Project ID"
  #default    = ""
}

variable "network_name" {
  description = "Name for Shared VPC network"
  #default    = ""
}

variable "vpc_project_id" {
  description = "Name for Shared VPC hosting GCP project"
  #default    = ""
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

variable "secondary_s01_range" {
  description = "Secondary IP range for the subnet"
  #default    = ""
}

variable "secondary_s02_range" {
  description = "Secondary IP range for the subnet"
  #default    = ""
}

variable "secondary_s03_range" {
  description = "Secondary IP range for the subnet"
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

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
  default     = ""
}
