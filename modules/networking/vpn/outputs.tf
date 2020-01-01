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
output "vpn_tunnels_names-dynamic" {
  description = "The VPN tunnel name is"
  value       = module.vpn_dynamic.vpn_tunnels_names-dynamic
}

output "ipsec_secret-dynamic" {
  description = "The secret"
  value       = module.vpn_dynamic.ipsec_secret-dynamic
}

output "gateway_ip" {
  description = "The VPN Gateway Public IP"
  value       = module.vpn_dynamic.gateway_ip
}
