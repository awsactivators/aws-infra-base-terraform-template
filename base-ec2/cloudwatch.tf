resource "aws_cloudwatch_log_group" "main" {
  name         = "${var.name}-log-group"
  skip_destroy = true
  tags         = local.tags
}

# CPU
resource "aws_cloudwatch_metric_alarm" "uptime_alarm" {
  alarm_name          = "${var.name}-utpime-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 24
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 3600
  datapoints_to_alarm = 24
  statistic           = "Maximum"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.uptime_alarm_sns_topic.arn]
  dimensions          = { InstanceId = aws_instance.main.id }
  tags                = local.tags
}

# Disk
resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  alarm_name          = "${var.name}-disk-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 3600
  datapoints_to_alarm = 3
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 disk utilization"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.uptime_alarm_sns_topic.arn]
  dimensions          = { InstanceId = aws_instance.main.id }
  tags                = local.tags
}

# Memory
resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name          = "${var.name}-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 3600
  datapoints_to_alarm = 3
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 memory utilization"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.uptime_alarm_sns_topic.arn]
  dimensions          = { InstanceId = aws_instance.main.id }
  tags                = local.tags
}


# SNS
resource "aws_sns_topic" "uptime_alarm_sns_topic" {
  name = "${var.name}-utpime-alarm-sns-topic"
  tags = local.tags
}

resource "aws_sns_topic_subscription" "uptime_alarm_sns_topic_subscription_user" {
  topic_arn = aws_sns_topic.uptime_alarm_sns_topic.arn
  protocol  = "email"
  endpoint  = var.usermail

  lifecycle {
    ignore_changes = [endpoint]
  }
}
resource "aws_sns_topic_subscription" "uptime_alarm_sns_topic_subscription_admin" {
  topic_arn = aws_sns_topic.uptime_alarm_sns_topic.arn
  protocol  = "email"
  endpoint  = var.adminmail

  lifecycle {
    ignore_changes = [endpoint]
  }
}
