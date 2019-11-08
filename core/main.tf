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

###############################################################################
#                          Provider Configuration
###############################################################################

provider "google" {
  credentials = file(local.credentials_file_path)
  version     = "~> 2.1"
}

provider "google-beta" {
  credentials = file(local.credentials_file_path)
  version     = "~> 2.1"
}

###############################################################################
#                          Project
###############################################################################

module "project-factory" {
  source                  = "../"
  random_project_id       = "false"
  name                    = var.project_id
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  credentials_path        = local.credentials_file_path
  default_service_account = var.default_service_account
  #bucket_location         = "europe-west1"
  #bucket_name             = "terraform-state"
  #bucket_project          = var.project_id
  #auto_create_network     = "false"
  activate_apis           = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
}