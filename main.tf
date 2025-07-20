module "vpn_gateway" {
  for_each = {
    for combo in flatten([
      for vpc_key, vpc_config in var.vpc_configs : [
        for vendor_key, vendor_config in var.vendor_configs : {
          key        = "${vpc_key}_${vendor_key}"
          vpc_key    = vpc_key
          vendor_key = vendor_key
        }
      ]
    ]) : combo.key => combo
  }

  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 4.0"

  vpn_gateway_id      = aws_vpn_gateway.main[each.key].id
  customer_gateway_id = aws_customer_gateway.vendors[each.value.vendor_key].id

  vpn_connection_static_routes_only         = true
  vpn_connection_static_routes_destinations = [var.vendor_configs[each.value.vendor_key].static_routes[each.value.vpc_key]]

  vpc_id = data.aws_vpc.vpc[each.value.vpc_key].id
  vpc_subnet_route_table_ids = [
    for key, rt in data.aws_route_table.private : rt.id
    if startswith(key, "${each.value.vpc_key}_")
  ]
  # Required by module for count calculations (legacy Terraform limitation)
  # Modern Terraform with for_each doesn't need this, but module still requires it
  vpc_subnet_route_table_count = length([
    for key, rt in data.aws_route_table.private : rt.id
    if startswith(key, "${each.value.vpc_key}_")
  ])

  local_ipv4_network_cidr  = var.vendor_configs[each.value.vendor_key].local_network_cidr
  remote_ipv4_network_cidr = var.vpc_configs[each.value.vpc_key].remote_cidr

  # CloudWatch logging configuration
  tunnel1_log_options = {
    cloudwatch_log_options = {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.vpn_tunnel1[each.key].arn
      log_output_format = "text"
    }
  }

  tunnel2_log_options = {
    cloudwatch_log_options = {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.vpn_tunnel2[each.key].arn
      log_output_format = "text"
    }
  }

  tags = {
    Name = "${each.value.vpc_key}-${each.value.vendor_key}-vpn-connection"
  }

  # Explicit dependencies to ensure proper resource creation order
  depends_on = [
    aws_customer_gateway.vendors,
    aws_vpn_gateway.main,
    aws_cloudwatch_log_group.vpn_tunnel1,
    aws_cloudwatch_log_group.vpn_tunnel2
  ]
}