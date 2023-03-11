variable "project" {
  description = "Project Environment"
  type        = string
}

variable "semester" {
  description = "Alt School Semester"
  type        = string
}

variable "subnets" {
  description = "subnets to use for the EKS cluster"
  type        = list(string)
}

variable "max_no_of_nodes" {
  description = "The maximum number of nodes to use for the EKS cluster"
  type        = number
}

variable "desired_no_of_nodes" {
  description = "The desired number of nodes to use for the EKS cluster"
  type        = number
}

variable "min_no_of_nodes" {
  description = "The minimum number of nodes to use for the EKS cluster"
  type        = number
}

variable "Owner" {
  description = "The owner of the resources"
  type        = string
  default     = "Kelvin Obioha"
}
variable "alb_security_groups" {
  description = "Comma separated list of security groups"
  type        = string
}

variable "autoscaling_average_cpu" {
  type        = number
  default     = 40
  description = "Average CPU threshold to autoscale EKS EC2 instances."
}

variable "vpc_id" {
  description = "The VPC ID to use for the EKS cluster"
  type        = string
}




