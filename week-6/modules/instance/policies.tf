resource "aws_iam_instance_profile" "public_profile" {
  name = "public_profile"
  role = aws_iam_role.public_role.name
}

resource "aws_iam_role" "public_role" {
  name = "public_role"

  managed_policy_arns = [
    aws_iam_policy.s3_policy.arn,
    aws_iam_policy.messages_policy.arn,
    aws_iam_policy.dynamodb_policy.arn,
  ]
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_instance_profile" "private_profile" {
  name = "private_profile"
  role = aws_iam_role.private_role.name
}

resource "aws_iam_role" "private_role" {
  name = "private_role"

  managed_policy_arns = [
    aws_iam_policy.s3_policy.arn,
    aws_iam_policy.messages_policy.arn,
    aws_iam_policy.rds_policy.arn,
  ]
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name = "s3_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "messages_policy" {
  name = "messages_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:*",
          "sns:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "rds_policy" {
  name = "rds_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "dynamodb_policy" {
  name = "dynamodb_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}