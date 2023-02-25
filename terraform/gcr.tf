

# Resource for creating a GCP container registry
resource "google_container_registry" "registry" {
  project  = var.project_id
  location = "EU"
}

