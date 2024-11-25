data "aws_ec2_transit_gateway" "external" {
  id = var.tgw
}

data "aws_vpc" "main" {
  id = var.vpc
}

data "aws_subnets" "all" {
  filter {
    name   = "vpi-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_route_tables" "all" {
  vpc_id = data.aws_vpc.main.id
}
