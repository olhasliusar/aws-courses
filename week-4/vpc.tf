resource "aws_vpc" "vpc_course" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lohika"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_course.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public_lohika"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_course.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private_lohika"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_course.id
  tags   = {
    Name = "lohika"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc_course.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_lohika"
  }
}

resource "aws_route_table_association" "public_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}
