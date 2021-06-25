locals {
  public_subnet_cidr = toset([
    for s in var.public_subnets.* : s.cidr_block
  ])
  public_subnet_ids = tolist([
    for s in var.public_subnets.* : s.id
  ])
  private_subnet_ids = tolist([
    for s in var.private_subnets.* : s.id
  ])
}

resource "aws_launch_template" "tmpl" {
  name = "lohika_final"

  image_id      = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.key_pair
  user_data     = base64encode(data.template_file.public_sh.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.public_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.allow_ssh_http.id]
    associate_public_ip_address = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name     = "asg"
  max_size = 2
  min_size = 2

  vpc_zone_identifier = local.public_subnet_ids

  target_group_arns = [aws_lb_target_group.lohika_lb_tg.arn]

  launch_template {
    id = aws_launch_template.tmpl.id
  }
}

resource "aws_instance" "nat" {
  ami                    = var.nat_instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id              = element(local.public_subnet_ids, 0)
  source_dest_check      = false

  tags = {
    Name = "nat"
  }
}

resource "aws_instance" "ec2_private" {
  ami                    = var.instance_ami
  instance_type          = "t2.micro"
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.private_ssh.id]
  subnet_id              = element(local.private_subnet_ids, 0)
  user_data              = base64encode(data.template_file.private_sh.rendered)
  iam_instance_profile   = aws_iam_instance_profile.private_profile.name

  tags = {
    Name = "private"
  }
}

resource "aws_route" "route_for_private_ec2" {
  route_table_id         = data.aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = aws_instance.nat.id
}
