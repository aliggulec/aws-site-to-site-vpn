# Customer Gateways (per vendor)
resource "aws_customer_gateway" "vendors" {
  for_each = var.vendor_configs

  bgp_asn    = each.value.bgp_asn
  ip_address = each.value.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "${each.key}-customer-gateway"
  }
}