variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "project" {
  type        = string
  description = "Project Environment"
}

variable "dns_base_domain" {
  type        = string
  description = "DNS Zone name to be used from EKS Ingress."
  #   modify with your own domain name
  default = "eks.kelyinc.xyz"
}

variable "ingress_gateway_name" {
  type        = string
  description = "Load-balancer service name."
  default     = "aws-load-balancer-controller"
}
variable "ingress_gateway_iam_role" {
  type        = string
  description = "IAM Role Name associated with load-balancer service."
  default     = "load-balancer-controller"
}
variable "ingress_gateway_chart_name" {
  type        = string
  description = "Ingress Gateway Helm chart name."
  default     = "aws-load-balancer-controller"
}
variable "ingress_gateway_chart_repo" {
  type        = string
  description = "Ingress Gateway Helm repository name."
  default     = "https://aws.github.io/eks-charts"
}
variable "ingress_gateway_chart_version" {
  type        = string
  description = "Ingress Gateway Helm chart version."
  default     = "1.4.1"
}

variable "external_dns_iam_role" {
  type        = string
  description = "IAM Role Name associated with external-dns service."
  default     = "external-dns"
}
variable "external_dns_chart_name" {
  type        = string
  description = "Chart Name associated with external-dns service."
  default     = "external-dns"
}

variable "external_dns_chart_repo" {
  type        = string
  description = "Chart Repo associated with external-dns service."
  default     = "https://kubernetes-sigs.github.io/external-dns/"
}

variable "external_dns_chart_version" {
  type        = string
  description = "Chart Repo associated with external-dns service."
  default     = "1.9.0"
}

variable "external_dns_values" {
  type        = map(string)
  description = "Values map required by external-dns service."
  default = {
    "image.repository"   = "k8s.gcr.io/external-dns/external-dns",
    "image.tag"          = "v0.11.0",
    "logLevel"           = "info",
    "logFormat"          = "json",
    "triggerLoopOnEvent" = "true",
    "interval"           = "5m",
    "policy"             = "sync",
    "sources"            = "{ingress}"
  }

}
