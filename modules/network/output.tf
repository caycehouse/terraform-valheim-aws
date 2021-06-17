output "valheim_vpc" {
  value = aws_vpc.valheim_vpc.id
}

output "valheim_subnet" {
  value = aws_subnet.valheim_subnet.id
}
