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
  description = "The ID of the billing account to associate this project with"
}

variable "all_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members that will get the extended permissions across all the folders."
  default     = []
}

variable "per_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members per folder who will get extended permissions."
  default     = []
}

variable "subnet_01_ip" {
  description = "IP range for the subnet"
}

variable "subnet_02_ip" {
  description = "IP range for the subnet"
}

variable "subnet_03_ip" {
  description = "IP range for the subnet"
}

variable "subnet_01_region" {
  description = "Region of subnet 1"
}

variable "subnet_02_region" {
  description = "Region of subnet 2"
}

variable "subnet_03_region" {
  description = "Region of subnet 3"
}

variable "local_subnet_01_ip" {
  description = "IP range of the on-prem network"
}

variable "router_region" {
  description = "The region in which you want to create the router"
}

variable "vpn_region" {
  description = "The region in which you want to create the VPN gateway"
}
