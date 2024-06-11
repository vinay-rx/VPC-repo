module "vpc" {
  #source = "git::https://git-codecommit.us-east-1.amazonaws.com/v1/repos/com-tf-modules/network/vpc?ref=v0.1"
  source = "../resources/vpc"
  env     = "${local.env}"
  project = "${local.project}"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  #az_list = ["us-east-1a","us-east-1b"]
  #single_nat_gw = true
  common_tags = local.common_tags
}

# module "environment" {
#   source = "../resources/enviornment"
#   env     = "${local.env}"
#   project = "${local.project}"
#   common_tags = local.common_tags
# }
