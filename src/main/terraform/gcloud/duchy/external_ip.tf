# Copyright 2023 The Cross-Media Measurement Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This is step number 10.a as per document
# https://github.com/world-federation-of-advertisers/cross-media-measurement/blob/main/docs/gke/duchy-deployment.md

resource "google_compute_address" "worker_requisition_fulfillment_server1a" {
  name = "worker-requisition-fulfillment-server-ip1a"
  region = local.zone
  project = var.project
}

resource "google_compute_address" "worker_computation_control_server1a" {
  name = "worker-computation-control-server-ip1a"
  region = local.zone
  project = var.project
}
