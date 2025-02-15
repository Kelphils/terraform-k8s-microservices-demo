data "aws_caller_identity" "main" {}

data "aws_route53_zone" "base_domain_name" {
  name = var.dns_base_domain
  tags = {
    Name = "eks_dns_name"
  }
}

# deploy 'external-dns' service
resource "helm_release" "external_dns" {
  name       = var.external_dns_chart_name
  chart      = var.external_dns_chart_name
  repository = var.external_dns_chart_repo
  version    = var.external_dns_chart_version
  namespace  = "kube-system"

  dynamic "set" {
    for_each = var.external_dns_values

    content {
      name  = set.key
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.main.account_id}:role/${var.external_dns_iam_role}"
  }

  set {
    name  = "domainFilters"
    value = "{${data.aws_route53_zone.base_domain_name.name}}"
  }

  set {
    name  = "txtOwnerId"
    value = data.aws_route53_zone.base_domain.zone_id
  }
}
