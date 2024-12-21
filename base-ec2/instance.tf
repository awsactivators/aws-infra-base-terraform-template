resource "aws_instance" "main" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.root_key.key_name
  disable_api_termination     = true
  source_dest_check           = false
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  user_data                   = data.cloudinit_config.user_data.rendered

  root_block_device {
    encrypted   = true
    volume_size = var.volume_size
  }
  tags = local.tags

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      instance_type,
      cpu_core_count,
      ebs_optimized,
      #instance_state,
      #public_dns,
      #public_ip,
      user_data,
    ]
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-instance_profile"
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role" "instance_role" {
  name = "${var.name}-instance_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = local.tags

}



resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "${var.name}-cloudwatch-policy"
  description = "Policy to allow access to cloudwatch"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Effect : "Allow",
        Resource : "${aws_cloudwatch_log_group.main.arn}:*"
      }
    ]
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch-policy-attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}


