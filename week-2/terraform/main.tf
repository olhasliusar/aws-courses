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
sudo amazon-linux-extras enable corretto8
sudo yum install java-1.8.0-amazon-corretto -y

sudo aws s3 cp s3://olga-lohika-bucket/file.txt file.txt
EOF
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_all"
  description = "Allow inbound SSH traffic and HTTP"
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

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3_profile"
  role = aws_iam_role.s3_role.name
}

resource "aws_iam_role" "s3_role" {
  name = "s3_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = aws_iam_role.s3_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_launch_template" "tmpl" {
  name = "launch_template"

  image_id      = var.instance_ami
  instance_type = "t2.micro"
  key_name      = var.key_pair
  user_data     = base64encode(data.template_file.sh.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.s3_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.allow_ssh_http.id]
    associate_public_ip_address = true
    subnet_id                   = var.subnet_id
  }
}

resource "aws_autoscaling_group" "asg" {
  name     = "asg"
  max_size = 2
  min_size = 2

  launch_template {
    id = aws_launch_template.tmpl.id
  }
}

//resource "aws_instance" "my_ec2" {
//  ami                    = var.instance_ami
//  instance_type          = "t2.micro"
//  iam_instance_profile   = aws_iam_instance_profile.s3_profile.name
//  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
//  subnet_id              = var.subnet_id
//  key_name               = var.key_pair
//  user_data              = data.template_file.sh.rendered
//}
