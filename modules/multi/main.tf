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

###############################################################################
#                          Networking (VPCs, Firewalls)
###############################################################################

locals {
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
    { role    = "roles/cloudmigration.storageaccess"
      members = ["serviceAccount:${google_service_account.velos-cloud-extension.email}"]
    }
  ]
}

/******************************************
  Network Creation
 *****************************************/

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.0"

  project_id   = module.vpc-project.project_id
  network_name = var.network_name

  delete_default_internet_gateway_routes = "false"
  shared_vpc_host                        = "true"

  subnets = [
    {
      subnet_name   = "${var.network_name}-subnet-01"
      subnet_ip     = var.subnet_01_ip
      subnet_region = var.subnet_01_region
    },
    {
      subnet_name           = "${var.network_name}-subnet-02"
      subnet_ip             = var.subnet_02_ip
      subnet_region         = var.subnet_02_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${var.network_name}-subnet-03"
      subnet_ip             = var.subnet_03_ip
      subnet_region         = var.subnet_03_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]

}

module "net-shared-vpc-access" {
  source              = "terraform-google-modules/network/google//modules/fabric-net-svpc-access"
  host_project_id     = module.vpc-project.project_id
  service_project_num = 3
  service_project_ids = [module.velo-project.project_id, module.prod-project.project_id, module.nonprod-project.project_id]
  host_subnets        = module.vpc.subnets_names
  host_subnet_regions = [var.subnet_01_region, var.subnet_02_region, var.subnet_03_region]
  host_subnet_users = {
    "${var.network_name}-subnet-01" = "serviceAccount:${module.velo-project.service_account_email},serviceAccount:${module.prod-project.service_account_email},serviceAccount:${module.nonprod-project.service_account_email}"
    "${var.network_name}-subnet-02" = "serviceAccount:${module.velo-project.service_account_email},serviceAccount:${module.prod-project.service_account_email},serviceAccount:${module.nonprod-project.service_account_email}"
    "${var.network_name}-subnet-03" = "serviceAccount:${module.velo-project.service_account_email},serviceAccount:${module.prod-project.service_account_email},serviceAccount:${module.nonprod-project.service_account_email}"
  }
  host_service_agent_role = true
  host_service_agent_users = [
    "serviceAccount:${google_service_account.velos-manager.email}",
    "serviceAccount:${google_service_account.velos-cloud-extension.email}",
  ]
}

/******************************************
  Firewall Rules Creation
 *****************************************/

resource "google_compute_firewall" "velos-backend-control" {
  name          = "velos-backend-control"
  description   = "Control plane between Velostrata Backend and Velostrata Manager"
  network       = var.network_name
  project       = module.vpc-project.project_id
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
  project       = module.vpc-project.project_id
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
  project     = module.vpc-project.project_id
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
  project     = module.vpc-project.project_id
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
  project     = module.vpc-project.project_id
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
  project       = module.vpc-project.project_id
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
  project       = module.vpc-project.project_id
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
  project       = module.vpc-project.project_id
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
#                          Projects
###############################################################################
module "vpc-project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 6.0"
  name              = "${var.project_prefix}-${var.velo_project_name}"
  random_project_id = "true"
  org_id            = var.organization_id
  folder_id         = var.velo_folder_id
  billing_account   = var.billing_account
  activate_apis     = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
}

module "velo-project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 6.0"
  name              = "${var.project_prefix}-${var.velo_project_name}"
  random_project_id = "true"
  org_id            = var.organization_id
  folder_id         = var.velo_folder_id
  billing_account   = var.billing_account
  activate_apis     = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
}

module "prod-project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 6.0"
  name              = "${var.project_prefix}-${var.prod_project_name}"
  random_project_id = "true"
  org_id            = var.organization_id
  folder_id         = var.prod_folder_id
  billing_account   = var.billing_account
  activate_apis     = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
}

module "nonprod-project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 6.0"
  name              = "${var.project_prefix}-${var.nonprod_project_name}"
  random_project_id = "true"
  org_id            = var.organization_id
  folder_id         = var.nonprod_folder_id
  billing_account   = var.billing_account
  activate_apis     = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
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
  project      = module.velo-project.project_id
}

resource "google_service_account" "velos-cloud-extension" {
  account_id   = "velos-cloud-extension"
  display_name = "velos-cloud-extension"
  project      = module.velo-project.project_id
}

/******************************************
  Bind Roles to Service Accounts
 *****************************************/

#Not using organizations_iam module due to for_each unable to compute
resource "google_organization_iam_binding" "serviceAccountUser" {
  org_id = var.organization_id
  role   = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${google_service_account.velos-manager.email}"
  ]
  depends_on = [google_service_account.velos-manager]
}

resource "google_organization_iam_binding" "velos_gcp_mgmt" {
  org_id = var.organization_id
  role   = "roles/cloudmigration.inframanager"
  members = [
    "serviceAccount:${google_service_account.velos-manager.email}"
  ]
  depends_on = [google_service_account.velos-cloud-extension]
}

#replaced IAM module due to for_each error.
resource "google_project_iam_binding" "iam" {
  count   = length(local.bindings)
  project = module.velo-project.project_id
  role    = local.bindings[count.index].role
  members = local.bindings[count.index].members
}

#for deploying velostrata from marketplace velo-proj Google APIs service account needs compute.networkUser on host
resource "google_project_iam_binding" "vpc-velo-proj-cloud-services-svc" {
  project = module.vpc-project.project_id
  role    = "roles/compute.networkUser"
  members = ["serviceAccount:${module.velo-project.project_number}@cloudservices.gserviceaccount.com"]
}
