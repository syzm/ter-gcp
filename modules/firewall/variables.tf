variable "network" {
  description = "Network for the firewall rule to be placed in."
  type = string
}

variable "instance_tags" {
  description = "The tags applied to instances to allow acscess."
  type        = list(string)
}