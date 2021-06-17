data "aws_region" "current" {}

resource "aws_vpc" "valheim_vpc" {
  cidr_block           = "10.0.0.0/16"
}

resource "aws_internet_gateway" "valheim_igw" {
  vpc_id = aws_vpc.valheim_vpc.id
}

resource "aws_default_route_table" "valheim_default_route" {
  default_route_table_id = aws_vpc.valheim_vpc.default_route_table_id
}

resource "aws_route" "valheim_route" {
  route_table_id         = aws_vpc.valheim_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.valheim_igw.id
  depends_on             = [aws_internet_gateway.valheim_igw]
}

resource "aws_subnet" "valheim_subnet" {
  availability_zone       = var.availability_zone
  vpc_id                  = aws_vpc.valheim_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.valheim_igw]
}
