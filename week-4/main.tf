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

resource "aws_instance" "ec2_in_private" {
  ami                    = var.instance_ami
  instance_type          = "t2.micro"
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.private_ssh_http.id]
  subnet_id              = aws_subnet.private_subnet.id

  tags = {
    Name = "private"
  }
}

resource "aws_instance" "ec2_in_public" {
  ami                    = var.instance_ami
  instance_type          = "t2.micro"
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  subnet_id              = aws_subnet.public_subnet.id

  tags = {
    Name = "public"
  }
}

resource "aws_instance" "nat" {
  ami                    = var.nat_instance_ami
  instance_type          = "t2.micro"
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id              = aws_subnet.public_subnet.id
  source_dest_check      = false

  tags = {
    Name = "nat"
  }
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH traffic and HTTP"
  vpc_id      = aws_vpc.vpc_course.id

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

resource "aws_security_group" "private_ssh_http" {
  name        = "private_ssh"
  description = "Allow SSH traffic and HTTP to private EC2"
  vpc_id      = aws_vpc.vpc_course.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all"
  vpc_id      = aws_vpc.vpc_course.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route" "route_for_private" {
  route_table_id         = aws_vpc.vpc_course.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = aws_instance.nat.id
}

resource "aws_lb_target_group" "lohika_lb_tg" {
  name     = "lohika"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_course.id
}

resource "aws_lb_target_group_attachment" "target_private" {
  target_group_arn = aws_lb_target_group.lohika_lb_tg.arn
  target_id        = aws_instance.ec2_in_private.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target_public" {
  target_group_arn = aws_lb_target_group.lohika_lb_tg.arn
  target_id        = aws_instance.ec2_in_public.id
  port             = 80
}

resource "aws_lb" "lohika_lb" {
  name               = "lohika"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lohika_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lohika_lb_tg.arn
  }
}
