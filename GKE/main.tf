# GKE cluster
data "google_container_engine_versions" "gke_version" {
  provider       = google-beta
  location       = var.region
  version_prefix = "1.30."
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = module.networks.private_network_name
  subnetwork = module.networks.subnetwork_name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name     = google_container_cluster.primary.name
  location = var.region
  cluster  = google_container_cluster.primary.name

  version    = data.google_container_engine_versions.gke_version.latest_node_version
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 50
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}



#enable services
module "project-services" {
  source     = "./modules/service-apis"
  project_id = var.project_id
}

#module for network
module "networks" {
  source     = "./modules/network"
  project_id = var.project_id
  region     = var.region
}