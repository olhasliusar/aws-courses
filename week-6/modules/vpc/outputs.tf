output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  value = toset([
    for s in aws_subnet.private_subnet : s
  ])
}

output "public_subnets" {
  value = toset([
    for s in aws_subnet.public_subnet : s
  ])
}
