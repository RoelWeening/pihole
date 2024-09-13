resource "aws_kms_key" "cloudwatch_encryption" {
  description             = "/ecs/logs"
  deletion_window_in_days = 30

  policy = <<EOF
{"Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${data.aws_region.current.name}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_alias" "cloudwatch_encryption" {
  name          = "alias/ecs/logs"
  target_key_id = aws_kms_key.cloudwatch_encryption.key_id
}