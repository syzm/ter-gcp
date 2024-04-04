resource "google_compute_firewall" "allow_iap" {
  name    = "allow-iap"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = var.instance_tags
}

# allow access from health check ranges
resource "google_compute_firewall" "default" {
  name          = "apache-xlb-fw-allow-hc"
  direction     = "INGRESS"
  network       = var.network
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}