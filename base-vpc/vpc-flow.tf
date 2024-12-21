resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  tags            = local.tags

}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.name}-cloudwatch-flow-log-group"
  tags = local.tags

}

resource "aws_iam_role" "vpc-flow-logs" {
  name = "${var.name}-vpc-flow-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = local.tags

}

resource "aws_iam_role_policy" "vpc-flow-logs" {
  name = "${var.name}-vpc-flow-logs-policy"
  role = aws_iam_role.vpc-flow-logs.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
