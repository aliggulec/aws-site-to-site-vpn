# VPN Gateways (per VPC per vendor)
resource "aws_vpn_gateway" "main" {
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

  vpc_id = data.aws_vpc.vpc[each.value.vpc_key].id

  tags = {
    Name = "${each.value.vpc_key}-${each.value.vendor_key}-vpn-gateway"
  }
}