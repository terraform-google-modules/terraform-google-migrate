/**
 * Copyright 2019 Google LLC
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


/******************************************
Velostrata VM IP Address
 *****************************************/

resource "google_compute_address" "velo-frontend-ip" {
  project = var.project_id
  region  = trimsuffix(var.velostrata_vm_zone, regex("-[^-]+$", var.velostrata_vm_zone))
  name    = "velostrata-frontend-ip"
}


/******************************************
Velostrata VM Instance
 *****************************************/

resource "google_compute_instance" "velo-vm" {
  project      = var.project_id
  name         = var.velostrata_vm_name
  machine_type = var.velostrata_vm_machine_type
  zone         = var.velostrata_vm_zone

  tags = concat(["fw-velosmanager"], var.velostrata_vm_tags)

  boot_disk {
    initialize_params {
      image = "projects/click-to-deploy-images/global/images/velostrata-mgmt-4-8-0-28082"
    }
  }

  network_interface {
    subnetwork         = var.subnet_name
    subnetwork_project = var.subnet_project
    access_config {
      nat_ip = google_compute_address.velo-frontend-ip.address
    }
  }

  metadata = {
    apiPassword              = var.velostrata_vm_password
    secretsEncKey            = var.velostrata_vm_encryption_key
    defaultServiceAccount    = var.cloud_extension_svc_email
    google-monitoring-enable = "1"
    google-logging-enable    = "1"
  }

  service_account {
    email  = var.velos_manager_svc_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform", "rpc://phrixus.googleapis.com/auth/cloudrpc"]
  }
}
resource "null_resource" "wait-for-velostrata" {
  provisioner "local-exec" {
    command = "curl --silent --retry 100 --retry-max-time 600 https://${google_compute_address.velo-frontend-ip.address} --insecure"
  }
  triggers = {
    vm_instance_id = google_compute_instance.velo-vm.instance_id
  }
  depends_on = [google_compute_instance.velo-vm]
}
