# aws_db_subnet_group, which designates a collection of subnets that RDS instance can be provisioned in. 
# This subnet group uses the subnets created by the VPC module.
resource "aws_db_subnet_group" "subnet_group" {
  name       = var.name
  subnet_ids = var.public_subnets
}

# todo:complete https://macro-eyes.atlassian.net/browse/COMP-38 and enable performance insights 
# tfsec:ignore:aws-rds-specify-backup-retention tfsec:ignore:aws-rds-enable-performance-insights
resource "aws_db_instance" "instance" {
  identifier             = "${var.name}-${var.environment}"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
  deletion_protection    = true
  publicly_accessible    = var.publicly_accessible # allow rds access from local machines
  skip_final_snapshot    = true
  # tfsec:ignore:aws-rds-encrypt-instance-storage-data
  storage_encrypted       = false # Disabled because when enabled decryption of data adds a "minimal" impact on performance
  backup_retention_period = 1
  # tfsec:ignore:* coudnt find the rule id for this warnnign :(
  iam_database_authentication_enabled = false #todo enable when  https://macro-eyes.atlassian.net/browse/STRIATA-521 is complete
  performance_insights_enabled        = var.enable_performance_insights ? true : false


  lifecycle {
    ignore_changes = [
      enabled_cloudwatch_logs_exports, password
    ]
  }
}
