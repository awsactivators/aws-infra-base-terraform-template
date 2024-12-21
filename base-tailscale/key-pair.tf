# root key pair
resource "aws_key_pair" "root_key" {
  key_name   = "${var.root_name}-vm-root-key"
  public_key = var.root_public_key
  tags       = local.tags
}
