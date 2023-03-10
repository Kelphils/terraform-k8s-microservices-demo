# # create IAM role for AWS Load Balancer Controller, and attach to EKS OIDC
# module "eks_ingress_iam" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 4.22.0"

#   role_name                              = "load-balancer-controller"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.cluster.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }
