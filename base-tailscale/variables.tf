variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  type        = string
}

variable "ami" {
  description = "AMI for VM"
  type        = string
}

variable "availability_zone" {
  description = "AZ to start VM in"
  type        = string
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch in"
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  description = "Key name of the root user key pair to use for the instance"
  type        = string
}

variable "volume_size" {
  description = "Size of root volume"
  default     = 100
  type        = number
}

variable "username" {
  description = "Name of end user"
  type        = string
}

variable "public_key" {
  description = "Public key for end user"
  type        = string
}

variable "usermail" {
  description = "Mail address of VM user"
  type        = string
}

variable "adminmail" {
  description = "Mail address of admin"
  type        = string
}

variable "falcon_cid" {
  description = "Customer id for Falcon"
  type        = string
}
variable "ec2_user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = ""

}

variable "tailscale_authkey" {
  type        = string
  description = "Tailscale pre authorized key"

}

variable "cidr_routes" {
  type        = string
  description = "Tailscale advertised routes"

}

variable "hostname" {
  type        = string
  description = "Instance host name"
}

variable "root_name" {
  type = string
}

variable "root_public_key" {
  type = string
}

variable "project_code" {
  type = string
}
