variable "subnet_id" {
  default = "The ID of created subnet"
  type    = string
}

variable "zone" {
  default = "Zone for the server"
  type    = string
}

variable "project" {
  default = "Project the server is in"
  type    = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}