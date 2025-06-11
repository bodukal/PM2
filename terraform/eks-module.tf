module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.0"

  cluster_name    = "java-api-cluster-v3"
  cluster_version = "1.27"

  vpc_id     = "vpc-0c2ec5ad7947c60d5"
  # Use only private subnets for better security
  subnet_ids = [
    "subnet-0c197d6f8a92d53db",  # private-subnet-2
    "subnet-0a764b4ed20ce0495"   # private-subnet-1
  ]

  # Changed from node_groups to eks_managed_node_groups
  eks_managed_node_groups = {
    java-api-nodes = {
      # Changed from desired_capacity to desired_size
      desired_size = 2
      max_size     = 3
      min_size     = 1
      
      instance_types = ["t3.medium"]
      
      # Disable launch template to allow remote access
      use_custom_launch_template = false
      
      # Now we can use remote access
      remote_access = {
        ec2_ssh_key = "saturday"
      }
    }
  }

  # Changed from manage_aws_auth to manage_aws_auth_configmap
  manage_aws_auth_configmap = false  # Disable to avoid connection issues
  enable_irsa              = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
