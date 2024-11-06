output "private_network_name" {
  value = google_compute_network.main.name
}


output "subnetwork_name" {
  value = google_compute_subnetwork.subnet.name
}