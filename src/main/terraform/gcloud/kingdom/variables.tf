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

locals {
  env = var.env
  project = var.project
  component = var.component
  zone = "us-central1"

  # e.g. Prefix will look like dev-halo-kingdom
  prefix = "${local.env}-${local.component}"

  spanner_db = {
    deletion_protection = false
    version_retention_period = "3d"
    num_nodes    = 1
  }

  kingdom = {
    # configured as per the document.
    name = "${local.prefix}-gke-cluster"
    cluster_node_count = 2 # TODO(wfa-dharmalingam): change it 3, once the quota increased
    machine_type = "e2-highcpu-2"
    min_node_count = 2 # TODO(wfa-dharmalingam): change it 3, once the quota increased
    max_node_count = 6
    auto_scaling = true
    database_encryption_state = "DECRYPTED" # state - (Required) ENCRYPTED or DECRYPTED
    encryption_key = "" #"projects/${local.project}/locations/${local.zone}/keyRings/test-key-ring/cryptoKeys/k8s-secret"
  }
  autoscaling_resource_limits = local.kingdom.auto_scaling ? concat([{
    resource_type = "cpu"
    minimum       = 1
    maximum       = 8
  }, {
    resource_type = "memory"
    minimum       = 2
    maximum       = 16
  }]): []

  kms = {
    ring_name = "test-key-ring"
  }
}

variable "project" {
  type = string
  default = "halo-cmm-sandbox"
  description = "Project name used"
}

variable env {
  type = string
  default = "dev"
  description = "Represents the environment used."
}

variable "component" {
  type = string
  default = "kingdom"
  description = "The component that we are developing."
}

variable "service_account" {
  type = string
  # TODO: Our approach is to put this in github secrets and fetch it during runtime and feed it here.
  default = "36966063264-compute@developer.gserviceaccount.com"
  description = "The Service account to be used to create these resources"
}