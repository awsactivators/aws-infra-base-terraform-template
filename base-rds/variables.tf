variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "environment" {
  description = "Environment to be used on all the resources as identifier"
  type        = string
}


variable "vpc_security_group_ids" {
  description = "A list of VPC security group ids"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}
variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
  sensitive   = true
}
variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = "100"
}

# Terraform will automatically hide differences with the allocated_storage argument value if autoscaling occurs.
variable "max_allocated_storage" {
  description = "The allocated storage in gigabytes. Enables auto scaling"
  type        = string
  default     = "1000"
}
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "13.7"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string

}

variable "enable_performance_insights" {
  description = "Enable Performance Insights for RDS instances"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Control if instance is publicly accessible"
  default     = false
}
