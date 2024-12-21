output "subnet_id" {
  value = aws_subnet.public.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "availability_zone" {
  value = aws_subnet.public.availability_zone
}