output "vpc_name" {
  value = module.vpc.vpc_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "region" {   value = var.region } 
output "public_subnet_ids" {   value = module.public_subnet_ids.public[*].id } 
output "route_table_ids" {   value = [module.route_table_id.public.id] } 
output "internet_gateway_id" {
  value = module.internet_gateway_id.vpc_id
}

