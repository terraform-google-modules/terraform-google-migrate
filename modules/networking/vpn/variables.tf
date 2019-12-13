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
variable "project_id" {
  type        = string
  description = "The ID of the project where this VPC will be created"
}

variable "network" {
  type        = string
  description = "The name of VPC being created"
}

variable "router_region" {
  type        = string
  description = "The region in which you want to create the router"
}

variable "vpn_region" {
  type        = string
  description = "The region in which you want to create the VPN gateway"
}
variable "router_name" {
  type        = string
  description = "The name for the router"
  default     = "router-vm-migrate"
}

variable "gateway_name" {
  type        = string
  description = "The name of VPN gateway"
  default     = "vpn-gw-vm-migrate"
}

variable "tunnel_count" {
  type        = number
  description = "The number of tunnels from each VPN gw"
  default     = 2
}

variable "tunnel_name_prefix" {
  type        = string
  description = "The optional custom name of VPN tunnel being created"
  default     = "vpn-tn-vm-migrate"
}

variable "peer_ips" {
  type        = list(string)
  description = "IP address of remote-peer/gateway"
  default     = ["1.1.1.1", "2.2.2.2"]
}

variable "shared_secret" {
  type        = string
  description = "Please enter the shared secret/pre-shared key"
  default     = "secret"
}

variable "peer_asn" {
  type        = list(string)
  description = "Please enter the ASN of the BGP peer that cloud router will use"
  default     = ["64516", "64517"]
}

variable "bgp_cr_session_range" {
  type        = list(string)
  description = "Please enter the cloud-router interface IP/Session IP"
  default     = ["169.254.1.1/30", "169.254.1.5/30"]
}

variable "bgp_remote_session_range" {
  type        = list(string)
  description = "Please enter the remote environments BGP Session IP"
  default     = ["169.254.1.2", "169.254.1.6"]
}

variable "bgp_asn" {
  type        = string
  description = "Please enter the ASN that cloud router will use"
  default     = "64515"
}
