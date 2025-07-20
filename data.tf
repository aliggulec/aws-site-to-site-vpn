# VPC Data Sources
data "aws_vpc" "vpc" {
  for_each = var.vpc_configs

  filter {
    name   = "tag:Name"
    values = [each.value.vpc_name]
  }
}

data "aws_subnets" "private" {
  for_each = var.vpc_configs

  filter {
    name   = "tag:Name"
    values = [each.value.subnet_name_filter]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc[each.key].id]
  }
}

data "aws_route_table" "private" {
  for_each = {
    for combo in flatten([
      for env, config in var.vpc_configs : [
        for subnet_id in data.aws_subnets.private[env].ids : {
          key       = "${env}_${subnet_id}"
          env       = env
          subnet_id = subnet_id
        }
      ]
    ]) : combo.key => combo
  }

  subnet_id = each.value.subnet_id
}