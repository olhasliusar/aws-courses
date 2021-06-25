data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "template_file" "public_sh" {
  template = <<-EOF
#!/bin/bash
sudo amazon-linux-extras enable corretto8
sudo yum install java-1.8.0-amazon-corretto -y
EOF
}

data "template_file" "private_sh" {
  template = <<-EOF
#!/bin/bash
sudo amazon-linux-extras enable corretto8
sudo yum install java-1.8.0-amazon-corretto -y

sudo yum install -y postgresql
export RDS_HOST=${var.rds_endpoint}
echo $RDS_HOST

EOF
}