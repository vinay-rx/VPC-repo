output "vpc_name" {
  value = module.vpc.vpc_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "region" {   value = var.region } 
output "public_subnet_ids" {   value = [module.vpc.public_subnet.*.ids] } 
output "route_table_ids" {   value = [module.vpc.route_table_id.rt_id] } 
output "internet_gateway_id" {
  value = module.vpc.igw.id
}

