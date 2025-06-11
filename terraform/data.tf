data "aws_vpc" "existing" {
  id = "vpc-0c2ec5ad7947c60d5"
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}
