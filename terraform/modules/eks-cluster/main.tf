data "aws_region" "current" {}

resource "aws_iam_role" "eks-iam-role" {
  name = "${var.project}-${var.semester}-eks-iam-role"

  path = "/"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF

  tags = {
    Name = "${var.project}-eks-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_eks_cluster" "alt-school-eks" {
  name     = "${var.project}-${var.semester}-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = var.subnets
  }

  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
  tags = {
    Name = "${var.project}-eks-cluster"
  }
}

resource "aws_iam_role" "eks-cluster-workernodes" {
  name = "${var.project}-${var.semester}-eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = {
    Name = "${var.project}-cluster-nodegroup-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-cluster-workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-cluster-workernodes.name
}

resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.eks-cluster-workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-cluster-workernodes.name
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.alt-school-eks.name
  node_group_name = "${var.project}-${var.semester}-workernodes"
  node_role_arn   = aws_iam_role.eks-cluster-workernodes.arn
  capacity_type   = "ON_DEMAND"
  subnet_ids      = var.subnets
  disk_size       = 10
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = var.desired_no_of_nodes
    max_size     = var.max_no_of_nodes
    min_size     = var.min_no_of_nodes
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name = "${var.project}-eks-node-group"
  }
}



# create EKS cluster
# module "eks-cluster" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 19.0"

#   cluster_name                    = "${var.project}-${var.semester}-cluster"
#   cluster_version                 = "1.25"
#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true
#   subnet_ids                      = var.subnets
#   vpc_id                          = module.vpc.vpc_id
#   eks_managed_node_groups         = var.eks_managed_node_groups

#   node_security_group_additional_rules = {
#     # https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/2039#issuecomment-1099032289
#     ingress_allow_access_from_control_plane = {
#       type                          = "ingress"
#       protocol                      = "tcp"
#       from_port                     = 9443
#       to_port                       = 9443
#       source_cluster_security_group = true
#     }
#     # allow connections from ALB security group
#     ingress_allow_access_from_alb_sg = {
#       type                     = "ingress"
#       protocol                 = "-1"
#       from_port                = 0
#       to_port                  = 0
#       source_security_group_id = aws_security_group.alb.id
#     }
#     # allow connections from EKS to the internet
#     egress_all = {
#       protocol         = "-1"
#       from_port        = 0
#       to_port          = 0
#       type             = "egress"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#     # allow connections from EKS to EKS (internal calls)
#     ingress_self_all = {
#       protocol  = "-1"
#       from_port = 0
#       to_port   = 0
#       type      = "ingress"
#       self      = true
#     }
#   }
# }
# output "cluster_id" {
#   value = module.cluster.cluster_id
# }

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

# # create IAM role for External DNS, and attach to EKS OIDC
# module "eks_external_dns_iam" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "~> 4.22.0"

#   role_name                     = "external-dns"
#   attach_external_dns_policy    = true
#   external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.cluster.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:external-dns"]
#     }
#   }
# }

# # set spot fleet Autoscaling policy
# resource "aws_autoscaling_policy" "eks_autoscaling_policy" {
#   count = length(var.eks_managed_node_groups)

#   name                   = "${module.cluster.eks_managed_node_groups_autoscaling_group_names[count.index]}-autoscaling-policy"
#   autoscaling_group_name = module.cluster.eks_managed_node_groups_autoscaling_group_names[count.index]
#   policy_type            = "TargetTrackingScaling"

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = var.autoscaling_average_cpu
#   }
# }
