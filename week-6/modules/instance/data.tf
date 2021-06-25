data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "template_file" "public_sh" {
  template = <<-EOF
#!/bin/bash
sudo amazon-linux-extras enable corretto8
sudo yum install java-1.8.0-amazon-corretto -y

sudo aws s3 cp s3://lohika-bucket/calc-0.0.2-SNAPSHOT.jar calc-0.0.2-SNAPSHOT.jar
java -jar calc-0.0.2-SNAPSHOT.jar

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

sudo aws s3 cp s3://lohika-bucket/persist3-0.0.1-SNAPSHOT.jar persist3-0.0.1-SNAPSHOT.jar
java -jar persist3-0.0.1-SNAPSHOT.jar

EOF
}