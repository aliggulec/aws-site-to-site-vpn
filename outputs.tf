output "vpn_gateway_ids" {
  description = "IDs of the VPN gateways"
  value = {
    for key, gateway in aws_vpn_gateway.main : key => gateway.id
  }
}

output "customer_gateway_ids" {
  description = "IDs of the customer gateways"
  value = {
    for key, gateway in aws_customer_gateway.vendors : key => gateway.id
  }
}

output "vpn_connection_ids" {
  description = "IDs of the VPN connections"
  value = {
    for key, connection in module.vpn_gateway : key => connection.vpn_connection_id
  }
}

output "cloudwatch_log_group_arns" {
  description = "ARNs of the CloudWatch log groups"
  value = {
    tunnel1 = {
      for key, log_group in aws_cloudwatch_log_group.vpn_tunnel1 : key => log_group.arn
    }
    tunnel2 = {
      for key, log_group in aws_cloudwatch_log_group.vpn_tunnel2 : key => log_group.arn
    }
  }
}