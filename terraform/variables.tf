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

variable "semester" {
  description = "Alt School Semester"
  default     = "third-semester"
  type        = string
}

variable "max_no_of_nodes" {
  description = "The maximum number of nodes to use for the EKS cluster"
  default     = 1
  type        = number
}

variable "desired_no_of_nodes" {
  description = "The desired number of nodes to use for the EKS cluster"
  default     = 1
  type        = number
}

variable "min_no_of_nodes" {
  description = "The minimum number of nodes to use for the EKS cluster"
  default     = 1
  type        = number
}

variable "Owner" {
  description = "The owner of the resources"
  type        = string
  default     = "Kelvin Obioha"
}
