resource "aws_efs_file_system" "efs_for_fargate" {
  creation_token  = "${var.Prefix}-EFS"
  encrypted       = true
  throughput_mode = "bursting"

  tags = {
    "Name" = "${var.Prefix}-EFS"
  }
}

resource "aws_efs_backup_policy" "efs_for_fargate" {
  file_system_id = aws_efs_file_system.efs_for_fargate.id

  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "subnet_mount" {
  for_each = toset(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.efs_for_fargate.id
  subnet_id       = each.value
  security_groups = [aws_security_group.sg_pihole_efs.id]

}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id                     = aws_efs_file_system.efs_for_fargate.id
  bypass_policy_lockout_safety_check = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs_for_fargate.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]
}
POLICY
}





