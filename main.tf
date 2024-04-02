terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.1.0"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
  zone = var.zone
}

module "network" {
  source  = "./modules/network"
  region = var.region
}

module "server" {
  source    = "./modules/server"
  subnet_id = module.network.subnet_id
  zone = var.zone
}