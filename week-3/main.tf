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

data "template_file" "sh" {
  template = <<-EOF
#!/bin/bash
sudo aws s3 cp s3://olga-lohika-bucket/rds-script.sql rds-script.sql
sudo aws s3 cp s3://olga-lohika-bucket/dynamodb-script.sh dynamodb-script.sh
sudo chmod +x dynamodb-script.sh
sudo yum install -y postgresql
EOF
}

resource "aws_db_instance" "pgsql" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.t2.micro"
  username             = var.postgres_user
  password             = var.postgres_password
  publicly_accessible  = true
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.postgres.id]
}

resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.dynamodb_table
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_instance" "my_ec2" {
  ami                    = var.instance_ami
  instance_type          = "t2.micro"
  key_name               = var.key_pair
  iam_instance_profile   = aws_iam_instance_profile.iam_profile.name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  user_data              = data.template_file.sh.rendered
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH traffic and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "postgres" {
  name        = "allow_postgres"
  description = "Allow Postgres connection"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
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
          "s3:*",
          "rds:*",
          "dynamodb:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
