variable "vpc_configs" {
  description = "VPC configuration for different environments"
  type = map(object({
    vpc_name           = string
    subnet_name_filter = string
    remote_cidr        = string
  }))
  default = {
    production = {
      vpc_name           = ""
      subnet_name_filter = ""
      remote_cidr        = ""
    }
    alpha = {
      vpc_name           = ""
      subnet_name_filter = ""
      remote_cidr        = ""
    }
  }
}

variable "vendor_configs" {
  description = "Vendor configuration for different vendors"
  type = map(object({
    bgp_asn            = number
    ip_address         = string
    local_network_cidr = string
    static_routes      = map(string)
  }))
  default = {
    vendor1 = {
      # - BGP ASN is redundant for static routing but AWS enforces usage
      # - Valid ranges: 2-byte ASN (1-65535) or 4-byte ASN (4200000000-4294967294)
      # - Private ASN ranges: 64512-65534 (16-bit) or 4200000000-4294967294 (32-bit)
      bgp_asn            = 65001
      ip_address         = "x.x.x.x"
      local_network_cidr = "10.0.0.0/8" # Client/vendor side network CIDR
      static_routes = {
        production = "10.0.0.1/32" # Vendor1 production environment
        alpha      = "10.0.0.2/32" # Vendor1 alpha environment
        dev       = "10.0.0.3/32" # Vendor1 dev environment
    }
    # Future vendors can be added here
    # vendor2 = {
    # - BGP ASN is redundant for static routing but AWS enforces usage
    # - Valid ranges: 2-byte ASN (1-65535) or 4-byte ASN (4200000000-4294967294)
    # - Private ASN ranges: 64512-65534 (16-bit) or 4200000000-4294967294 (32-bit)
    #   bgp_asn           = 65001
    #   ip_address        = "x.x.x.x"
    #   local_network_cidr = "10.0.0.0/8"  # Client/vendor side network CIDR
    #   static_routes = {
    #     production = "10.0.0.1/32"  # Vendor2 production environment
    #     alpha      = "10.0.0.2/32"  # Vendor2 alpha environment
    #     dev        = "10.0.0.3/32"  # Vendor2 dev environment
    #   }
    # }
  }
}
}


variable "cloudwatch_log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 90
}