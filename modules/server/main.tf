# Instance template for a web-server
resource "google_compute_instance_template" "my_template" {
  name_prefix  = "xfce-template-"
  machine_type = "e2-standard-2"

  disk {
    source_image = "projects/nd-proj-419109/global/images/xfce-instance"
    boot         = true
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  tags = ["web-server", "allow-health-check"]
  lifecycle {
    create_before_destroy = true
  }

  metadata_startup_script = data.template_file.startup_script.rendered
}

# Managed instance group for the app
resource "google_compute_instance_group_manager" "mig" {
  # Workaround to recreate mig on template change
  name = substr("my-mig-${md5(google_compute_instance_template.my_template.name)}", 0, 63)
  base_instance_name = "apache-instance"
  zone               = var.zone
  target_size        = var.instance_count
  version {
    instance_template = google_compute_instance_template.my_template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Reserved IP address
resource "google_compute_global_address" "default" {
  name = "apache-xlb-static-ip"
}

# Forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "apache-xlb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# Http proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "apache-xlb-target-http-proxy"
  url_map = google_compute_url_map.default.id
}

# Url map
resource "google_compute_url_map" "default" {
  name            = "apache-xlb-url-map"
  default_service = google_compute_backend_service.default.id
}

# Backend service
resource "google_compute_backend_service" "default" {
  name          = "apache-xlb-backend-service"
  port_name     = "http"
  protocol      = "HTTP"
  health_checks = [google_compute_health_check.default.id]
  backend {
    group = google_compute_instance_group_manager.mig.instance_group
  }
}

# Health check
resource "google_compute_health_check" "default" {
  name = "apache-xlb-health-check"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
  check_interval_sec = 5
  timeout_sec        = 5
}

data "template_file" "startup_script" {
  template = <<EOF
    #!/bin/bash

    sudo apt-get update && sudo apt-get -y install apache2

    dpkg-query --status tightvncserver > /dev/null 2>&1
    rc=$?
    if [  "$rc" -ne "0" ];
    then
      echo "Installing vnc components"
      DEBIAN_FRONTEND=noninteractive apt-get install xfce4 xfce4-goodies tightvncserver -y
      mkdir --parents ~/.vnc
      echo "Szymon19" | vncpasswd -f > ~/.vnc/passwd
      chmod 600 ~/.vnc/passwd
    fi
    vncserver :1

    sudo systemctl start apache2

    echo '<!doctype html><html><body><h1>Hello You Successfully was able to run a webserver on GCP with Terraform!</h1></body></html>' | sudo tee /var/www/html/index.html
    EOF
}
