# S3 Bucket for Long-term Log Storage (Loki)
resource "aws_s3_bucket" "logs" {
  bucket = "sample-platform-logs-${data.aws_caller_identity.current.account_id}-${var.cluster_name}"
  tags   = var.tags
}

# IAM Role for Loki to write to S3 (IRSA)
module "loki_s3_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.cluster_name}-loki-s3"

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["monitoring:loki"]
    }
  }

  role_policy_arns = {
    s3 = aws_iam_policy.loki_s3.arn
  }
}

resource "aws_iam_policy" "loki_s3" {
  name        = "${var.cluster_name}-loki-s3-policy"
  description = "Allow Loki to read/write to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.logs.arn,
          "${aws_s3_bucket.logs.arn}/*"
        ]
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

output "log_bucket_name" {
  value = aws_s3_bucket.logs.id
}

output "loki_role_arn" {
  value = module.loki_s3_role.iam_role_arn
}
