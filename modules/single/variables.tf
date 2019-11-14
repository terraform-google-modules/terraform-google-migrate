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

variable "credentials_path" {
  description = "Path to a service account credentials file with rights to run the Project Factory. If this file is absent Terraform will fall back to Application Default Credentials."
  default     = "~/.config/gcloud/application_default_credentials.json"
}

variable "network_name" {
  description = "Name for the VPC network"
  default     = "velo-network"
}

variable "project_id" {
  description = "Project ID for GCP project"
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
