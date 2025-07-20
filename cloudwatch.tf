# CloudWatch Log Groups for VPN tunnels (per VPC per vendor)
resource "aws_cloudwatch_log_group" "vpn_tunnel1" {
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

  name              = "/aws/vpn/${each.value.vpc_key}-${each.value.vendor_key}-tunnel1"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = {
    Name        = "${each.value.vpc_key}-${each.value.vendor_key}-vpn-tunnel1-logs"
    Environment = each.value.vpc_key
    Vendor      = each.value.vendor_key
  }
}

resource "aws_cloudwatch_log_group" "vpn_tunnel2" {
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

  name              = "/aws/vpn/${each.value.vpc_key}-${each.value.vendor_key}-tunnel2"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = {
    Name        = "${each.value.vpc_key}-${each.value.vendor_key}-vpn-tunnel2-logs"
    Environment = each.value.vpc_key
    Vendor      = each.value.vendor_key
  }
}