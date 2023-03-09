# run the command below to specify the path for configuration of the
# terraform state in S3 bucket with the DynamoDb table as the backend and encryption, locking enabled
# terraform init -backend-config=backend.hcl

module "vpc" {
  source                   = "./modules/vpc"
  second_octet             = var.second_octet
  no_of_availability_zones = var.no_of_availability_zones
  project                  = var.project

}
