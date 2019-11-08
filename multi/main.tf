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
  version     = "~> 2.7.0"
}

provider "google-beta" {
  credentials = file(local.credentials_file_path)
  version     = "~> 2.7.0"
}

###############################################################################
#                          Networking (VPCs, Firewalls)
###############################################################################

locals {
  subnet_01             = "${var.network_name}-subnet-01"
  subnet_02             = "${var.network_name}-subnet-02"
  subnet_03             = "${var.network_name}-subnet-03"
}

/******************************************
  Network Creation
 *****************************************/

module "vpc" {
  # TODO: Switch to released version once
  # https://github.com/terraform-google-modules/terraform-google-network/pull/47
  # is merged and released.  This is here to fix the `Error: Unsupported block
  # type` on the `triggers` block in network's main.tf file.
  #
  # source  = "terraform-google-modules/network/google"
  # version = "0.8.0"
  source = "git::https://github.com/terraform-google-modules/terraform-google-network.git?ref=master"

  project_id   = var.vpc_project_id
  network_name = var.network_name

  delete_default_internet_gateway_routes = "true"
  shared_vpc_host                        = "true"

  subnets = [
    {
      subnet_name   = local.subnet_01
      subnet_ip     = var.subnet_01_ip
      subnet_region = var.subnet_01_region
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = var.subnet_02_ip
      subnet_region         = var.subnet_02_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = local.subnet_03
      subnet_ip             = var.subnet_03_ip 
      subnet_region         = var.subnet_03_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]

  secondary_ranges = {
    "${local.subnet_01}" = [
      {
        range_name    = "${local.subnet_01}-01"
        ip_cidr_range = var.secondary_s01_range
      },
    ]

    "${local.subnet_02}" = [
      {
        range_name    = "${local.subnet_02}-01"
        ip_cidr_range = var.secondary_s02_range
      },
    ]

    "${local.subnet_03}" = [
      {
        range_name    = "${local.subnet_03}-01"
        ip_cidr_range = var.secondary_s03_range
      },
    ]
  }
}

/******************************************
  Firewall Rules Creation
 *****************************************/

resource "google_compute_firewall" "velos-backend-control" {
  name          = "velos-backend-control"
  description   = "Control plane between Velostrata Backend and Velostrata Manager"
  network       = var.network_name
  project       = var.vpc_project_id
  source_ranges = [var.local_subnet_01_ip]
  target_tags   = ["fw-velosmanager"]
  depends_on    = ["module.vpc"]

  allow {
    protocol = "tcp"
    ports    = ["9119"]
  }
}

resource "google_compute_firewall" "velos-ce-backend" {
  name          = "velos-ce-backend"
  description   = "Encrypted migration data sent from Velostrata Backend to Cloud Extensions"
  network       = var.network_name
  project       = var.vpc_project_id
  source_ranges = [var.local_subnet_01_ip]
  target_tags   = ["fw-velostrata"]
  depends_on    = ["module.vpc"]

  allow {
    protocol = "tcp"
    ports    = ["9111"]
  }
}

resource "google_compute_firewall" "velos-ce-control" {
  name          = "velos-ce-control"
  description   = "Control plane between Cloud Extensions and Velostrata Manager"
  network       = var.network_name
  project       = var.vpc_project_id
  source_tags   = ["fw-velosmanager"]
  target_tags   = ["fw-velostrata"]
  depends_on    = ["module.vpc"]

  allow {
    protocol = "tcp"
    ports    = ["443", "9111"]
  }
}

resource "google_compute_firewall" "velos-ce-cross" {
  name          = "velos-ce-cross"
  description   = "Synchronization between Cloud Extension nodes"
  network       = var.network_name
  project       = var.vpc_project_id
  source_tags   = ["fw-velostrata"]
  target_tags   = ["fw-velostrata"]
  depends_on    = ["module.vpc"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "velos-console-probe" {
  name          = "velos-console-probe"
  description   = "Allows the Velostrata Manager to check if the SSH or RDP console on the migrated VM is available"
  network       = var.network_name
  project       = var.vpc_project_id
  source_tags   = ["fw-velosmanager"]
  target_tags   = ["fw-workload"]
  depends_on    = ["module.vpc"]

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_firewall" "velos-vcplugin" {
  name          = "velos-vcplugin"
  description   = "Control plane between vCenter plugin and Velostrata Manager"
  network       = var.network_name
  project       = var.vpc_project_id
  source_ranges = [var.local_subnet_01_ip]
  target_tags   = ["fw-velosmanager"]
  depends_on    = ["module.vpc"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "velos-webui" {
  name          = "velos-webui"
  description   = "HTTPS access to Velostrata Manager for web UI"
  network       = var.network_name
  project       = var.vpc_project_id
  source_ranges = [var.local_subnet_01_ip, "10.10.20.0/24"]
  target_tags   = ["fw-velosmanager"]
  depends_on    = ["module.vpc"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "velos-workload" {
  name          = "velos-workload"
  description   = "iSCSI for data migration and syslog"
  network       = var.network_name
  project       = var.vpc_project_id
  source_ranges = [var.local_subnet_01_ip, "10.10.20.0/24"]
  target_tags   = ["fw-velosmanager"]
  depends_on    = ["module.vpc"]

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

module "velo-project" {
  source                  = "../"
  random_project_id       = "false"
  name                    = var.velo_project_id
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  credentials_path        = local.credentials_file_path
  default_service_account = var.default_service_account
  activate_apis           = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
  shared_vpc              = var.vpc_project_id
  shared_vpc_subnets = [
    "projects/${var.vpc_project_id}/regions/${var.subnet_01_region}/subnetworks/${local.subnet_01}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_02_region}/subnetworks/${local.subnet_02}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_03_region}/subnetworks/${local.subnet_03}",
  ]
}

module "prod-project" {
  source                  = "../"
  random_project_id       = "false"
  name                    = var.prod_project_id
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  credentials_path        = local.credentials_file_path
  default_service_account = var.default_service_account
  activate_apis           = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
  shared_vpc              = var.vpc_project_id
  shared_vpc_subnets = [
    "projects/${var.vpc_project_id}/regions/${var.subnet_01_region}/subnetworks/${local.subnet_01}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_02_region}/subnetworks/${local.subnet_02}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_03_region}/subnetworks/${local.subnet_03}",
  ]
}

module "stage-project" {
  source                  = "../"
  random_project_id       = "false"
  name                    = var.stage_project_id
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  credentials_path        = local.credentials_file_path
  default_service_account = var.default_service_account
  activate_apis           = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
  shared_vpc              = var.vpc_project_id
  shared_vpc_subnets = [
    "projects/${var.vpc_project_id}/regions/${var.subnet_01_region}/subnetworks/${local.subnet_01}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_02_region}/subnetworks/${local.subnet_02}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_03_region}/subnetworks/${local.subnet_03}",
  ]
}

module "test-project" {
  source                  = "../"
  random_project_id       = "false"
  name                    = var.test_project_id
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  credentials_path        = local.credentials_file_path
  default_service_account = var.default_service_account
  activate_apis           = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "storage-component.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
  shared_vpc              = var.vpc_project_id
  shared_vpc_subnets = [
    "projects/${var.vpc_project_id}/regions/${var.subnet_01_region}/subnetworks/${local.subnet_01}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_02_region}/subnetworks/${local.subnet_02}",
    "projects/${var.vpc_project_id}/regions/${var.subnet_03_region}/subnetworks/${local.subnet_03}",
  ]
}

###############################################################################
#                          IAM (service accounts, roles)
###############################################################################

/******************************************
  Custom Roles
 *****************************************/

resource "google_organization_iam_custom_role" "velos_gcp_mgmt_role" {
  role_id          = "velosMgmt"
  title            = "Velostrata Manager"
  description      = "Velostrata Manager"
  permissions      = ["compute.addresses.create", "compute.addresses.createInternal", "compute.addresses.delete", "compute.addresses.deleteInternal", "compute.addresses.get", "compute.addresses.list", "compute.addresses.setLabels", "compute.addresses.use", "compute.addresses.useInternal", "compute.diskTypes.get", "compute.diskTypes.list", "compute.disks.create", "compute.disks.delete", "compute.disks.get", "compute.disks.list", "compute.disks.setLabels", "compute.disks.update", "compute.disks.use", "compute.disks.useReadOnly", "compute.images.get", "compute.images.list", "compute.images.useReadOnly", "compute.instances.attachDisk", "compute.instances.create", "compute.instances.delete", "compute.instances.detachDisk", "compute.instances.get", "compute.instances.getSerialPortOutput", "compute.instances.list", "compute.instances.reset", "compute.instances.setDiskAutoDelete", "compute.instances.setLabels", "compute.instances.setMachineType", "compute.instances.setMetadata", "compute.instances.setMinCpuPlatform", "compute.instances.setScheduling", "compute.instances.setServiceAccount", "compute.instances.setTags", "compute.instances.start", "compute.instances.startWithEncryptionKey", "compute.instances.stop", "compute.instances.update", "compute.instances.updateNetworkInterface", "compute.instances.use", "compute.licenseCodes.get", "compute.licenseCodes.list", "compute.licenseCodes.update", "compute.licenseCodes.use", "compute.licenses.get", "compute.licenses.list", "compute.machineTypes.get", "compute.machineTypes.list", "compute.networks.get", "compute.networks.list", "compute.networks.use", "compute.networks.useExternalIp", "compute.nodeTemplates.list", "compute.projects.get", "compute.regionOperations.get", "compute.regions.get", "compute.regions.list", "compute.subnetworks.get", "compute.subnetworks.list", "compute.subnetworks.use", "compute.subnetworks.useExternalIp", "compute.zoneOperations.get", "compute.zones.get", "compute.zones.list", "iam.serviceAccounts.get", "iam.serviceAccounts.list", "resourcemanager.projects.get", "storage.buckets.create", "storage.buckets.delete", "storage.buckets.get", "storage.buckets.list", "storage.buckets.update", "storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.list", "storage.objects.update"]
  org_id           = var.organization_id
  depends_on       = ["module.velo-project"]
}

resource "google_project_iam_custom_role" "velos_gcp_ce_role" {
  role_id     = "velosCe"
  title       = "Velostrata Storage Access"
  description = "Velostrata Storage Access"
  permissions = ["storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.list", "storage.objects.update"]
  project     = var.velo_project_id
  depends_on  = ["module.velo-project"]
}

/******************************************
 Service Accounts
 *****************************************/

resource "google_service_account" "velos-manager" {
  account_id   = "velos-manager"
  display_name = "velos-manager"
  project      = var.velo_project_id
  depends_on   = ["google_organization_iam_custom_role.velos_gcp_mgmt_role", "google_project_iam_custom_role.velos_gcp_ce_role"]
}

resource "google_service_account" "velos-cloud-extension" {
  account_id   = "velos-cloud-extension"
  display_name = "velos-cloud-extension"
  project      = var.velo_project_id
  depends_on   = ["google_organization_iam_custom_role.velos_gcp_mgmt_role", "google_project_iam_custom_role.velos_gcp_ce_role"]
}

/******************************************
  Bind Roles to Service Accounts
 *****************************************/

resource "google_project_iam_binding" "serviceAccountTokenCreator" {
  project = var.velo_project_id
  role    = "roles/iam.serviceAccountTokenCreator"
    members = [
        "serviceAccount:velos-manager@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-manager"]
}

resource "google_organization_iam_binding" "serviceAccountUser" {
  org_id = var.organization_id
  role    = "roles/iam.serviceAccountUser"
    members = [
        "serviceAccount:velos-manager@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-manager"]
}

resource "google_project_iam_binding" "logWriter" {
  project = var.velo_project_id
  role    = "roles/logging.logWriter"
    members = [
        "serviceAccount:velos-manager@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-manager"]
}

resource "google_project_iam_binding" "metricWriter" {
  project = var.velo_project_id
  role    = "roles/monitoring.metricWriter"
    members = [
        "serviceAccount:velos-manager@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-manager"]
}

resource "google_project_iam_binding" "monitoring" {
  project = var.velo_project_id
  role    = "roles/monitoring.viewer"
    members = [
        "serviceAccount:velos-manager@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-manager"]
}

resource "google_project_iam_binding" "logWriter-ce" {
  project = var.velo_project_id
  role    = "roles/logging.logWriter"
    members = [
        "serviceAccount:velos-cloud-extension@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-cloud-extension"]
}

resource "google_project_iam_binding" "metricWriter-ce" {
  project = var.velo_project_id
  role    = "roles/monitoring.metricWriter"
    members = [
        "serviceAccount:velos-cloud-extension@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-cloud-extension"]
}

resource "google_organization_iam_binding" "velos_gcp_mgmt" {
  org_id = var.organization_id
  role    = "organizations/${var.organization_id}/roles/velosMgmt"
    members = [
        "serviceAccount:velos-manager@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-cloud-extension"]
}

resource "google_project_iam_binding" "velos_gcp_ce" {
  project = var.velo_project_id
  role    = "projects/${var.velo_project_id}/roles/velosCe"
    members = [
        "serviceAccount:velos-cloud-extension@${var.velo_project_id}.iam.gserviceaccount.com"
    ]
  depends_on = ["google_service_account.velos-cloud-extension"]
}