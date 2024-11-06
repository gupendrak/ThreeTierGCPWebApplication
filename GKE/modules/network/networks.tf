#VPC
resource "google_compute_network" "main" {
  provider                = google-beta
  name                    = "${var.project_id}-private-network"
  auto_create_subnetworks = false
  project                 = var.project_id
}


# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.main.name
  ip_cidr_range = "10.10.0.0/24"
}