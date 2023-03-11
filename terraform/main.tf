# run the command below to specify the path for configuration of the
# terraform state in S3 bucket with the DynamoDb table as the backend and encryption, locking enabled
# terraform init -backend-config=backend.hcl

module "vpc" {
  source                   = "./modules/vpc"
  second_octet             = var.second_octet
  no_of_availability_zones = var.no_of_availability_zones
  project                  = var.project

}

module "eks-cluster" {
  source              = "./modules/eks-cluster"
  project             = var.project
  semester            = var.semester
  subnets             = module.vpc.private_subnets_id
  max_no_of_nodes     = var.max_no_of_nodes
  desired_no_of_nodes = var.desired_no_of_nodes
  min_no_of_nodes     = var.min_no_of_nodes
  vpc_id              = module.vpc.vpc_id
  alb_security_groups = module.vpc.alb_sg_id
}
