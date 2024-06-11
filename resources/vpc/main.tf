locals {
  # Create list of route table ids
  # private_rt_ids = [
  #   for key, value in aws_route_table.private_rt : value.id
  # ]
  # public_rt_ids = [
  #   aws_route_table.public_rt.id
  # ]
  # route_tables = [
  #   for key, value in concat(local.private_rt_ids, local.public_rt_ids) : {
  #     key   = key
  #     rt_id = value
  #   }
  # ]

  any_port     = 0
  https_port   = "443"
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]

  common_tags = tomap({
    "Env"=var.env,
    "VPC"=var.vpc_name,
    "Project"=var.project,
    "ManagedBy"="Terraform"
    "Customer"="Test"
  })
}

# Get Current Region
data "aws_region" "current" {}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    tomap({
      "Name"=var.vpc_name,
          "Project"=var.project,
          
})
  )
}

# #VPC Flow logs
# # TODO: Enable VPC FLow Logs

# # Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id

#   tags = merge(
#     local.common_tags,
#     tomap({
#       "Name"="${var.vpc_name}_igw",
#       "Project"=var.project
# })
#   )
# }

# # NAT Gateways
# resource "aws_eip" "nat_gw" {
#   count = var.single_nat_gw ? 1 : length(var.az_list)
#   vpc   = true

#   tags = merge(
#     local.common_tags
#   )
# }

# resource "aws_nat_gateway" "nat_gw" {
#   count         = var.single_nat_gw ? 1 : length(var.az_list)
#   allocation_id = aws_eip.nat_gw.*.id[count.index]
#   subnet_id     = aws_subnet.public_subnet.*.id[count.index]

#   tags = merge(
#     local.common_tags,
#     tomap({
#       "Name"="${var.vpc_name}_nat_gw_${count.index + 1}",
#           "Project"=var.project,
# })
#   )

#   depends_on = [aws_internet_gateway.igw]
# }

# # Public Subnets
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = merge(
#     local.common_tags,
#     tomap({
#       "Name"="${var.vpc_name}_public_rt",
#       "Tier"="Public",
#           "Project"=var.project,
# })
#   )
# }

# resource "aws_subnet" "public_subnet" {
#   count                   = length(var.az_list)
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
#   map_public_ip_on_launch = true
#   availability_zone       = var.az_list[count.index]

#   tags = merge(
#     local.common_tags,
#     tomap({
#       "Name"="${var.vpc_name}_public_subnet_${count.index + 1}",
#       "Tier"="Public",
#           "Project"=var.project,
# })
#   )
# }

# resource "aws_route_table_association" "public_rt_assoc" {
#   count          = length(aws_subnet.public_subnet)
#   subnet_id      = aws_subnet.public_subnet.*.id[count.index]
#   route_table_id = aws_route_table.public_rt.id
# }

# # Private Subnets
# resource "aws_route_table" "private_rt" {
#   count = length(aws_nat_gateway.nat_gw)

#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw.*.id[count.index]
#   }

#   tags = merge(
#     local.common_tags,
#     tomap({
#       "Name"="${var.vpc_name}_private_rt_${count.index + 1}",
#       "Tier"="Private",
#           "Project"=var.project,
# })
#   )
# }

# resource "aws_subnet" "private_subnet" {
#   count                   = length(var.az_list)
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 2, count.index + 1)
#   map_public_ip_on_launch = false
#   availability_zone       = var.az_list[count.index]

#   tags = merge(
#     local.common_tags,
#     tomap({
#       "Name"="${var.vpc_name}_private_subnet_${count.index + 1}",
#       "Tier"="Private",
#           "Project"=var.project,
# })
#   )
# }

# resource "aws_route_table_association" "private_rt_assoc" {
#   count          = length(aws_subnet.private_subnet)
#   subnet_id      = aws_subnet.private_subnet.*.id[count.index]
#   route_table_id = var.single_nat_gw ? aws_route_table.private_rt.*.id[0] : aws_route_table.private_rt.*.id[count.index]
# }


# resource "aws_security_group" "sg" {
#   name = "${var.env}-${var.project}-common_sg"
#   vpc_id = aws_vpc.vpc.id
#   description = "Terraformed"

#  tags = merge(
#     var.common_tags
#   )
# }

# resource "aws_security_group_rule" "egress_all" {
#   type              = "egress"
#   security_group_id = aws_security_group.sg.id
#   from_port         = local.any_port
#   to_port           = local.any_port
#   protocol          = local.any_protocol
#   cidr_blocks       = local.all_ips
#   description       = "Allow All Traffic Out"
# }

# resource "aws_security_group_rule" "ingress_all" {
#   type              = "ingress"
#   security_group_id = aws_security_group.sg.id
#   from_port         = local.any_port
#   to_port           = local.any_port
#   protocol          = local.any_protocol
#   self              = true
#   description       = "Allow all traffic within self sg"
# }