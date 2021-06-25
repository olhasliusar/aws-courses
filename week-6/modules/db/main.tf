resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.dynamodb_table
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserName"

  attribute {
    name = "UserName"
    type = "S"
  }
}

resource "aws_db_instance" "pgsql" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = "db.t2.micro"
  name                 = var.postgres_db_name
  username             = var.postgres_user
  password             = var.postgres_password
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet.name
}

resource "aws_db_subnet_group" "postgres_subnet" {
  name       = "postgres_subnet"
  subnet_ids = toset([
    for s in var.postgres_subnets.* : s.id
  ])
}

resource "aws_security_group" "postgres" {
  name        = "allow_postgres"
  description = "Allow Postgres connection"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = toset([
      for s in var.postgres_subnets.* : s.cidr_block
    ])
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
