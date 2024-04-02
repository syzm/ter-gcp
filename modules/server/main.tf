resource "google_compute_instance" "my_instance" {
  count        = var.instance_count
  name         = "my-instance-${count.index}"
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

resource "google_service_account" "instance_sa" {
  count = var.instance_count
  account_id   = "instance-sa-${count.index}"
  display_name = "Instance Service Account ${count.index}"
}

resource "google_project_iam_member" "project1" {
  count   = var.instance_count
  project = var.project
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${google_service_account.instance_sa[count.index].email}"
}