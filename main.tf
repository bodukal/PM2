provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "comm-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  enable_nat_gateway         = false
  single_nat_gateway         = false
  enable_dns_hostnames       = true
  enable_dns_support         = true
  map_public_ip_on_launch    = true  # ✅ ensures EKS nodes get public IPs
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.1"

  cluster_name    = "comm-eks-cluster"
  cluster_version = "1.28"

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      subnet_ids     = module.vpc.public_subnets
    }
  }
}

