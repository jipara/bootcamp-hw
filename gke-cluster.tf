resource "google_container_cluster" "gke-cluster" {
  provider = google
  project            = var.project_id
  name               = "${var.app_name}-cluster"
  location           = var.gcp_zone_1
  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}