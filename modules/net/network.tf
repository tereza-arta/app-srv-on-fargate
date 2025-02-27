data "aws_availability_zones" "this" {}

resource "aws_vpc" "vpc" {
  count      = 1
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "priv" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.vpc[0].cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  vpc_id            = aws_vpc.vpc[0].id
}

resource "aws_subnet" "pub" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.vpc[0].cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc[0].id
}

resource "aws_route" "this" {
  route_table_id         = aws_vpc.vpc[0].main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "eip" {
  count      = 2
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  count         = 2
  subnet_id     = element(aws_subnet.pub.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
}

resource "aws_route_table" "priv" {
  count  = 2
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
}

resource "aws_route_table_association" "priv" {
  count          = 2
  subnet_id      = element(aws_subnet.priv.*.id, count.index)
  route_table_id = element(aws_route_table.priv.*.id, count.index)
}
