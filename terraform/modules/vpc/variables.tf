variable "second_octet" {
  description = "The second octet of the CIDR block (10.X.0.0/16) that will be used for the VPC"
  type        = string
}

variable "project" {
  description = "Project Environment"
  type        = string
}

variable "no_of_availability_zones" {
  description = "The number of availability zones to use for the VPC"
  type        = number
}

variable "Owner" {
  description = "The owner of the resources"
  type        = string
  default     = "Kelvin Obioha"
}
