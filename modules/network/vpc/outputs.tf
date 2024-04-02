output "subnet_id" {
  value = google_compute_subnetwork.my_subnet.self_link
}

output "network_self_link" {
  description = "The self link of the network."
  value       = google_compute_network.my_vpc.self_link
}
