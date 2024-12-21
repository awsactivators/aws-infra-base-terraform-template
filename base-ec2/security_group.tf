resource "aws_security_group" "security_group" {
  name        = "${var.name}-vm-sg"
  description = "SG for ${var.name}"
  vpc_id      = var.vpc_id

  ingress = [{
    cidr_blocks      = []
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22

  }]
  egress = [
    {
      description      = null
      self             = null
      prefix_list_ids  = null
      security_groups  = null
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  tags = local.tags

  lifecycle {
    ignore_changes = [
      ingress,
    ]
  }
}
