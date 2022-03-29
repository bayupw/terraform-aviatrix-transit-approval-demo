# ---------------------------------------------------------------------------------------------------------------------
# AWS Transit
# ---------------------------------------------------------------------------------------------------------------------
module "aws_transit_1" {
  source                = "terraform-aviatrix-modules/mc-transit/aviatrix"
  cloud                 = "aws"
  name                  = var.transit_gw_name
  region                = var.aws_region
  cidr                  = cidrsubnet(var.cloud_supernet, 8, 255)
  account               = var.aws_account
  insane_mode           = var.hpe
  instance_size         = var.aws_instance_size
  ha_gw                 = var.ha_gw
  local_as_number       = var.transit_gw_asn
  learned_cidr_approval = true
  learned_cidrs_approval_mode = "gateway"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Spoke
# ---------------------------------------------------------------------------------------------------------------------
module "aws_spoke" {
  count = var.spoke_gws

  source        = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  cloud         = "AWS"
  name          = "${var.spoke_gw_name}${count.index + 1}"
  cidr          = cidrsubnet(var.cloud_supernet, 8, 101 + count.index)
  region        = var.aws_region
  account       = var.aws_account
  transit_gw    = module.aws_transit_1.transit_gateway.gw_name
  insane_mode   = var.hpe
  instance_size = var.aws_instance_size
  ha_gw         = var.ha_gw
}

# ---------------------------------------------------------------------------------------------------------------------
# On-Prem
# ---------------------------------------------------------------------------------------------------------------------
module "onprem" {
  source              = "github.com/gleyfer/aviatrix-demo-onprem-aws"
  hostname            = "Onprem"
  tunnel_proto        = "IPsec"
  network_cidr        = cidrsubnet(var.onprem_supernet, 8, 200)
  public_subnets      = [cidrsubnet(var.onprem_supernet, 9, 400)]
  private_subnets     = [cidrsubnet(var.onprem_supernet, 9, 401)]
  instance_type       = "t3.medium"
  public_conns        = ["${module.aws_transit_1.transit_gateway.gw_name}:${module.aws_transit_1.transit_gateway.local_as_number}:1"]
  csr_bgp_as_num      = var.onprem_asn
  create_client       = false
  advertised_prefixes = ["0.0.0.0/0"]
  key_name = var.key_name
  depends_on = [module.aws_transit_1]
}