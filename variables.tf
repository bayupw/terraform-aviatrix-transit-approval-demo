# ---------------------------------------------------------------------------------------------------------------------
# CIDR
# ---------------------------------------------------------------------------------------------------------------------
variable "cloud_supernet" {
  type    = string
  default = "10.0.0.0/8"
}

variable "onprem_supernet" {
  type    = string
  default = "192.168.0.0/16"
}

variable "aws_account" {
  type        = string
  description = "Aviatrix AWS access account"
}

variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "AWS region"
}

variable "transit_gw_asn" {
  type        = number
  default     = 65501
  description = "Transit Gateway ASN"
}

variable "onprem_asn" {
  type        = number
  default     = 65511
  description = "OnPrem Router ASN"
}

variable "aws_instance_size" {
  type        = string
  default     = "t2.micro" #hpe "c5.xlarge"
  description = "AWS gateway instance size"
}

variable "spoke_gws" {
  type        = number
  default     = 2
  description = "Number of spoke gateways"
}

variable "hpe" {
  type        = bool
  default     = false
  description = "Insane mode"
}

variable "ha_gw" {
  type        = bool
  default     = true
  description = "Enable HA gateway"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS EC2
# ---------------------------------------------------------------------------------------------------------------------
variable "key_name" {
  type        = string
  default     = null
  description = "Existing SSH public key name"
}