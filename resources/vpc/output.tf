output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "vpc_name" {
    value = var.vpc_name
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnet.*.id
}