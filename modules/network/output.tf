output "valheim_vpc" {
  value = module.vpc.vpc_id
}

output "valheim_subnet" {
  value = module.vpc.public_subnets[0]
}

output "vpc_cidr_block" {
  value = module.vpc.public_subnets_cidr_blocks[0]
}
