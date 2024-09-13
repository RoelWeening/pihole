data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_subnet" "selected" {
  id = element(var.public_subnet_ids, 0)
}