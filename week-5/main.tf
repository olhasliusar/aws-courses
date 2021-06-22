terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "lohika-course"
  region  = "us-west-2"
}

resource "aws_sqs_queue" "queue" {
  name = "lohika-queue"
}

resource "aws_sns_topic" "sns" {
  name = "lohika-sns"
}

resource "aws_sns_topic_subscription" "lohika-subs" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = var.sns_subs_email
}

resource "aws_instance" "my_ec2" {
  ami                  = var.instance_ami
  instance_type        = "t2.micro"
  key_name             = var.key_pair
  iam_instance_profile = aws_iam_instance_profile.iam_profile.name
  security_groups      = [aws_security_group.allow_ssh.name]
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam_profile"
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role" "iam_role" {
  name = "iam_role"

  assume_role_policy = jsonencode({
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

resource "aws_iam_role_policy" "iam_policy" {
  name = "iam_policy"
  role = aws_iam_role.iam_role.id

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
