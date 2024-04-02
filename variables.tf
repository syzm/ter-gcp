variable "project" {
  description = "GCP project ID"
  type = string
  default = "nd-proj-419109"
}

variable "region" {
  description = "Region where resources will be created."
  type = string
  default     = "europe-west3"
}

variable "zone" {
  description = "Zone where resources will be created."
  type = string
  default     = "europe-west3-c"
}