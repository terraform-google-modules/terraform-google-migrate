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

/*****************************************
  Folder Structure
 *****************************************/
module "migration-folders" {
  source            = "terraform-google-modules/folders/google"
  version           = "~> 2.0"
  parent            = var.parent_folder == null ? "organizations/${var.organization_id}" : var.parent_folder
  names             = ["velos"]
  set_roles         = true
  per_folder_admins = var.per_folder_admins
  all_folder_admins = var.all_folder_admins
}

/*****************************************
  Velostrata Single Project Deployment
 *****************************************/

module "velos-single-project" {
  source                       = "../../modules/single"
  organization_id              = var.organization_id
  billing_account              = var.billing_account
  folder_id                    = split("/", module.migration-folders.ids["velos"])[1]
  subnet_01_ip                 = var.subnet_01_ip
  subnet_02_ip                 = var.subnet_02_ip
  subnet_03_ip                 = var.subnet_03_ip
  subnet_01_region             = var.subnet_01_region
  subnet_02_region             = var.subnet_02_region
  subnet_03_region             = var.subnet_03_region
  local_subnet_01_ip           = var.local_subnet_01_ip
  velostrata_vm_password       = var.velostrata_vm_password
  velostrata_vm_encryption_key = var.velostrata_vm_encryption_key

}

/*****************************************
  VPN
 *****************************************/
module "velos-vpn" {
  source        = "../../modules/networking/vpn"
  project_id    = module.velos-single-project.project_id
  network       = module.velos-single-project.network_name
  router_region = var.router_region
  vpn_region    = var.vpn_region
}
