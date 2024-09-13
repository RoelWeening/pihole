resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/ecs/container_cluster_${var.Prefix}"
  retention_in_days = 30

  kms_key_id = aws_kms_key.cloudwatch_encryption.arn

  tags = {
    Name = "/ecs/container_cluster_${var.Prefix}"
  }
}