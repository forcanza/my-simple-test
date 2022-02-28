data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.base_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc-${var.env}"
  }
}

#NAT gateway
resource "aws_eip" "nat_eip_for_nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip_for_nat.id
  subnet_id     = aws_subnet.public_subnets.0.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}


# Public
resource "aws_subnet" "public_subnets" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "public-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "gw-${var.env}"
  }
}

resource "aws_route_table" "rt_gw" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-rt-${var.env}"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.rt_gw.id
}
