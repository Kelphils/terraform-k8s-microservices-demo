
output "cluster_id" {
  value       = module.eks-cluster.cluster_id
  description = "The EKS cluster ID"
}


output "cluster_name" {
  value       = module.eks-cluster.cluster_name
  description = "The EKS cluster name"
}
