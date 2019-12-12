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
  subnet_01 = "${var.network_name}-subnet-01"
  subnet_02 = "${var.network_name}-subnet-02"
  subnet_03 = "${var.network_name}-subnet-03"
  bindings = [
    { role    = "roles/iam.serviceAccountTokenCreator"
      members = ["serviceAccount:${google_service_account.velos-manager.email}"]
    },
    { role    = "roles/iam.serviceAccountUser"
      members = ["serviceAccount:${google_service_account.velos-manager.email}"]
    },
    { role = "roles/logging.logWriter"
      members = [
        "serviceAccount:${google_service_account.velos-manager.email}",
        "serviceAccount:${google_service_account.velos-cloud-extension.email}"
      ]
    },
    { role = "roles/monitoring.metricWriter"
      members = [
        "serviceAccount:${google_service_account.velos-manager.email}",
        "serviceAccount:${google_service_account.velos-cloud-extension.email}"
      ]
    },
    { role    = "roles/monitoring.viewer"
      members = ["serviceAccount:${google_service_account.velos-manager.email}"]
    },
    { role    = "roles/cloudmigration.inframanager"
      members = ["serviceAccount:${google_service_account.velos-manager.email}"]
    },
    { role    = "roles/cloudmigration.storageaccess"
      members = ["serviceAccount:${google_service_account.velos-cloud-extension.email}"]
    }
  ]
}
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

###############################################################################
#                          Project
###############################################################################

module "velos-project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 5.0"
  name                    = var.project_name == "" ? "velos-core-project-${random_string.suffix.result}" : var.project_name
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = var.default_service_account
  folder_id               = var.folder_id
  activate_apis           = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
}
###############################################################################
#                          Networking (VPCs, Firewalls)
###############################################################################

/******************************************
  Network Creation
 *****************************************/

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 1.4.3"

  project_id   = module.velos-project.project_id
  network_name = var.network_name

  delete_default_internet_gateway_routes = "true"
  shared_vpc_host                        = "false"

  subnets = [
    {
      subnet_name   = local.subnet_01
      subnet_ip     = var.subnet_01_ip
      subnet_region = var.subnet_01_region
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = var.subnet_02_ip
      subnet_region         = var.subnet_01_region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
    {
      subnet_name           = local.subnet_03
      subnet_ip             = var.subnet_03_ip
      subnet_region         = var.subnet_01_region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
  ]

}

/******************************************
  Firewall Rules Creation
 *****************************************/

resource "google_compute_firewall" "velos-backend-control" {
  name          = "velos-backend-control"
  description   = "Control plane between Velostrata Backend and Velostrata Manager"
  network       = var.network_name
  project       = module.velos-project.project_id
  source_ranges = [var.local_subnet_01_ip]
  target_tags   = ["fw-velosmanager"]
  depends_on    = [module.vpc]

  allow {
    protocol = "tcp"
    ports    = ["9119"]
  }
}

resource "google_compute_firewall" "velos-ce-backend" {
  name          = "velos-ce-backend"
  description   = "Encrypted migration data sent from Velostrata Backend to Cloud Extensions"
  network       = var.network_name
  project       = module.velos-project.project_id
  source_ranges = [var.local_subnet_01_ip]
  target_tags   = ["fw-velostrata"]
  depends_on    = [module.vpc]

  allow {
    protocol = "tcp"
    ports    = ["9111"]
  }
}

resource "google_compute_firewall" "velos-ce-control" {
  name        = "velos-ce-control"
  description = "Control plane between Cloud Extensions and Velostrata Manager"
  network     = var.network_name
  project     = module.velos-project.project_id
  source_tags = ["fw-velosmanager"]
  target_tags = ["fw-velostrata"]
  depends_on  = [module.vpc]

  allow {
    protocol = "tcp"
    ports    = ["443", "9111"]
  }
}

resource "google_compute_firewall" "velos-ce-cross" {
  name        = "velos-ce-cross"
  description = "Synchronization between Cloud Extension nodes"
  network     = var.network_name
  project     = module.velos-project.project_id
  source_tags = ["fw-velostrata"]
  target_tags = ["fw-velostrata"]
  depends_on  = [module.vpc]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "velos-console-probe" {
  name        = "velos-console-probe"
  description = "Allows the Velostrata Manager to check if the SSH or RDP console on the migrated VM is available"
  network     = var.network_name
  project     = module.velos-project.project_id
  source_tags = ["fw-velosmanager"]
  target_tags = ["fw-workload"]
  depends_on  = [module.vpc]

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_firewall" "velos-vcplugin" {
  name          = "velos-vcplugin"
  description   = "Control plane between vCenter plugin and Velostrata Manager"
  network       = var.network_name
  project       = module.velos-project.project_id
  source_ranges = [var.local_subnet_01_ip]
  target_tags   = ["fw-velosmanager"]
  depends_on    = [module.vpc]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "velos-webui" {
  name          = "velos-webui"
  description   = "HTTPS access to Velostrata Manager for web UI"
  network       = var.network_name
  project       = module.velos-project.project_id
  source_ranges = [var.local_subnet_01_ip, "10.10.20.0/24"]
  target_tags   = ["fw-velosmanager"]
  depends_on    = [module.vpc]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "velos-workload" {
  name          = "velos-workload"
  description   = "iSCSI for data migration and syslog"
  network       = var.network_name
  project       = module.velos-project.project_id
  source_ranges = [var.local_subnet_01_ip, "10.10.20.0/24"]
  target_tags   = ["fw-velosmanager"]
  depends_on    = [module.vpc]

  allow {
    protocol = "tcp"
    ports    = ["3260"]
  }
  allow {
    protocol = "udp"
    ports    = ["514"]
  }
}

###############################################################################
#                          IAM (service accounts, roles)
###############################################################################

/******************************************
 Service Accounts
 *****************************************/

resource "google_service_account" "velos-manager" {
  account_id   = "velos-manager"
  display_name = "velos-manager"
  project      = module.velos-project.project_id
}

resource "google_service_account" "velos-cloud-extension" {
  account_id   = "velos-cloud-extension"
  display_name = "velos-cloud-extension"
  project      = module.velos-project.project_id
}

/******************************************
  Bind Roles to Service Accounts
 *****************************************/
#replaced IAM module due to for_each error.
resource "google_project_iam_binding" "iam" {
  count   = length(local.bindings)
  project = module.velos-project.project_id
  role    = local.bindings[count.index].role
  members = local.bindings[count.index].members
}
