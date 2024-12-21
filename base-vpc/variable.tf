variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "availability_zone_sub" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
}

variable "private_subnet" {
  description = "Private subnet CIDR"
}

variable "public_subnet" {
  description = "Public subnet CIDR"
}
