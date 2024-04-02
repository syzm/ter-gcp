resource "google_compute_instance" "my_instance" {
  name         = "my-instance"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  tags = ["web-server"]
}