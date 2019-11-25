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

locals {
  credentials_file_path = var.credentials_path
}
/*****************************************
  Folder Structure
 *****************************************/
module "migration-folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"
  # parent = "organizations/${var.organization_id}"
  parent            = "folders/619261348000"
  names             = ["core-project", "velo", "prod", "stg", "test"]
  set_roles         = true
  per_folder_admins = var.per_folder_admins
  all_folder_admins = var.all_folder_admins
}

/*****************************************
  Core Project
 *****************************************/

module "core-project" {
  source           = "../../modules/core"
  organization_id  = var.organization_id
  billing_account  = var.billing_account
  credentials_path = var.credentials_path
  folder_id        = split("/", module.migration-folders.ids["core-project"])[1]
}

/*****************************************
  Velostrata Single Project Deployment
 *****************************************/

module "velos-multi-project" {
  source              = "../../modules/multi"
  organization_id     = var.organization_id
  billing_account     = var.billing_account
  vpc_project_id      = module.core-project.project_id
  velo_folder_id      = split("/", module.migration-folders.ids["velo"])[1]
  prod_folder_id      = split("/", module.migration-folders.ids["prod"])[1]
  stg_folder_id       = split("/", module.migration-folders.ids["stg"])[1]
  test_folder_id      = split("/", module.migration-folders.ids["test"])[1]
  credentials_path    = var.credentials_path
  subnet_01_ip        = var.subnet_01_ip
  subnet_02_ip        = var.subnet_02_ip
  subnet_03_ip        = var.subnet_03_ip
  secondary_s01_range = var.secondary_s01_range
  secondary_s02_range = var.secondary_s02_range
  secondary_s03_range = var.secondary_s03_range
  subnet_01_region    = var.subnet_01_region
  subnet_02_region    = var.subnet_02_region
  subnet_03_region    = var.subnet_03_region
  local_subnet_01_ip  = var.local_subnet_01_ip

}
/*****************************************
  VPN
 *****************************************/
module "velos-vpn" {
  source        = "../../modules/networking/vpn"
  project_id    = module.core-project.project_id
  network       = module.velos-multi-project.network_name
  router_region = var.router_region
  vpn_region    = var.vpn_region
}
