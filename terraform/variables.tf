variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  default     = "alt-school"
}


variable "second_octet" {
  description = "The second octet of the CIDR block (10.X.0.0/16) that will be used for the VPC"
  default     = "6"
  type        = string
}

variable "project" {
  description = "Project Environment"
  default     = "alt-school-project"
  type        = string
}

variable "no_of_availability_zones" {
  description = "The number of availability zones to use for the VPC"
  default     = 3
  type        = number
}
