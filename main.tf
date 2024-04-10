terraform {
  backend "gcs" {
    bucket = "ter-backend"
    prefix = "sand/"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.1.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_storage_bucket" "default" {
  name          = "ter-backend"
  force_destroy = true
  location      = "EU"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

module "network" {
  source = "./modules/network/vpc"
  region = var.region
}

module "server" {
  source    = "./modules/server"
  subnet_id = module.network.subnet_id
  zone      = var.zone
  project   = var.project
}

module "firewall" {
  source        = "./modules/network/firewall"
  network       = module.network.network_self_link
  instance_tags = ["web-server"]
}

module "nat" {
  source  = "./modules/network/nat"
  network = module.network.network_self_link
  region  = var.region
  project = var.project
}