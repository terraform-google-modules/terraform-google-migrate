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


resource "google_compute_router" "cr_to_mgt_vpc" {
  name    = var.router_name
  region  = var.router_region
  network = var.network
  project = var.project_id

  bgp {
    asn = var.bgp_asn
  }
}

module "vpn_dynamic" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.5"

  project_id         = var.project_id
  network            = var.network
  region             = var.vpn_region
  gateway_name       = var.gateway_name
  tunnel_name_prefix = var.tunnel_name_prefix
  shared_secret      = var.shared_secret
  tunnel_count       = var.tunnel_count
  peer_ips           = var.peer_ips

  cr_enabled               = true
  cr_name                  = google_compute_router.cr_to_mgt_vpc.name
  bgp_cr_session_range     = var.bgp_cr_session_range
  bgp_remote_session_range = var.bgp_remote_session_range
  peer_asn                 = var.peer_asn
}
