locals {
  vpc_subnets = var.vpc_subnets == null ? length(data.aws_availability_zones.az.names) : var.vpc_subnets
}

module "subnet_addrs" {
  source          = "hashicorp/subnets/cidr"
  version         = "~> 1.0"
  base_cidr_block = "${var.vpc_network_address}/${var.vpc_network_mask}"
  networks        = [for idx in range(local.vpc_subnets * 2) : { name = idx, new_bits = var.vpc_subnet_new_bits }]
}

resource "aws_vpc" "vpc" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = module.subnet_addrs.base_cidr_block
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = merge(
    {
      Name = "${var.id}-vpc"
      TFID = var.id
  }, var.aws_tags)
}

resource "aws_subnet" "public_subnets" {
  count                   = local.vpc_subnets
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  cidr_block              = module.subnet_addrs.networks[count.index].cidr_block
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "${var.id}-vpc-public-subnet-${count.index + 1}-${data.aws_availability_zones.az.names[count.index]}", Access = "public"
      TFID = var.id
  }, var.aws_tags)
}

resource "aws_subnet" "private_subnets" {
  count                   = local.vpc_subnets
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  cidr_block              = module.subnet_addrs.networks[count.index + local.vpc_subnets].cidr_block
  map_public_ip_on_launch = false
  tags = merge(
    {
      Name = "${var.id}-vpc-private-subnet-${count.index + 1}-${data.aws_availability_zones.az.names[count.index]}", Access = "private"
      TFID = var.id
  }, var.aws_tags)
}


resource "aws_route_table" "public_rtb" {
  count  = length(aws_subnet.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.id}-vpc-public-rtb", Access = "public"
      TFID = var.id
  }, var.aws_tags)
}

resource "aws_route" "public_igw" {
  count                  = length(aws_subnet.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public_rtb[0].id
  gateway_id             = aws_internet_gateway.igw[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private_rtb" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.id}-vpc-private-rtb-${count.index + 1}-${aws_subnet.private_subnets[count.index].availability_zone}", Access = "private"
      TFID = var.id
  }, var.aws_tags)
}

resource "aws_route" "private_nat" {
  count                  = var.nat ? length(aws_subnet.private_subnets) : 0
  route_table_id         = aws_route_table.private_rtb[count.index].id
  nat_gateway_id         = var.nat_multi_az ? aws_nat_gateway.nat_gw[count.index].id : aws_nat_gateway.nat_gw[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rtb_assoc" {
  count          = length(aws_subnet.public_subnets)
  route_table_id = aws_route_table.public_rtb[0].id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table_association" "private_rtb_assoc" {
  count          = length(aws_subnet.private_subnets)
  route_table_id = aws_route_table.private_rtb[count.index].id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

resource "aws_internet_gateway" "igw" {
  count  = length(aws_subnet.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.id}-vpc-igw", Access = "public"
      TFID = var.id
  }, var.aws_tags)
}

resource "aws_eip" "nat_gw_eip" {
  count = (length(aws_subnet.private_subnets) > 0 && var.nat) ? (var.nat_multi_az ? length(aws_subnet.private_subnets) : 1) : 0
  tags = merge(
    {
      Name = "${var.id}-vpc-eip-${aws_subnet.public_subnets[count.index].availability_zone}", Access = "public"
      TFID = var.id
  }, var.aws_tags)
}

resource "aws_nat_gateway" "nat_gw" {
  count         = (length(aws_subnet.private_subnets) > 0 && var.nat) ? (var.nat_multi_az ? length(aws_subnet.private_subnets) : 1) : 0
  subnet_id     = aws_subnet.public_subnets[count.index].id
  allocation_id = aws_eip.nat_gw_eip[count.index].id
  tags = merge(
    {
      Name = "${var.id}-vpc-nat-${aws_subnet.public_subnets[count.index].availability_zone}", Access = "public"
      TFID = var.id
  }, var.aws_tags)
}

resource "aws_flow_log" "vpc_flow_logs" {
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = data.aws_s3_bucket.flow_logs_bucket.arn
  vpc_id               = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.id}-vpc-flow-logs"
      TFID = var.id
    },
  var.aws_tags)
  destination_options {
    file_format        = "parquet"
    per_hour_partition = true
  }
}
