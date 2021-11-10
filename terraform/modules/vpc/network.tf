##########
# VPC
##########
resource "aws_vpc" "vpc" {
  count   = var.vpc_module_enabled ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "igw" {

  count   = var.vpc_module_enabled ? 1 : 0
  vpc_id = var.vpc_id
  tags = merge(
    { Name = "${var.name}-igw"},
    var.tags,
  )
}

# #####################
# #Elastic IP
# #####################
 resource "aws_eip" "eip" {
   count    = var.vpc_module_enabled ? 1 : 0
   vpc      = true
 }

# #####################
# #NAT Gateway Creation
# #####################
resource "aws_nat_gateway" "nat_gw" {
  count   = var.vpc_module_enabled ? 1 : 0
  allocation_id = aws_eip.eip.0.id
  subnet_id     = aws_subnet.pub_sub.0.id

  tags = merge(
    {
      Name = "${var.name}-nat-gw"
    },
    var.tags,
  )
}

###############
# Public Subnet
###############
resource "aws_subnet" "pub_sub" {

  count = var.vpc_module_enabled && length(var.pub_subnet_cidr) > 0 ? length(var.pub_subnet_cidr) : 0

  vpc_id     = var.vpc_id
  cidr_block = element(var.pub_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    {
      Name = "${var.name}-${var.public_subnet_suffix}-${element(var.availability_zones, count.index)}"
    },
    var.tags,
  )
}

################
# Private Subnet
################
resource "aws_subnet" "priv_sub" {

  count = var.vpc_module_enabled && length(var.priv_subnet_cidr) > 0 ? length(var.priv_subnet_cidr) : 0

  vpc_id     = var.vpc_id
  cidr_block = element(var.priv_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    {
      Name = "${var.name}-${var.priv_subnet_suffix}-${element(var.availability_zones, count.index)}"
    },
    var.tags,
  )
}

####################
# Public Route Table
####################
resource "aws_route_table" "public_rt" {
  count   = var.vpc_module_enabled ? 1 : 0
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.0.id
  }
  tags = merge(
    {
      Name = "${var.name}-pub-rt"
    },
    var.tags,
  )
}

#####################
# Private Route Table
#####################
resource "aws_route_table" "private_rt" {
  count   = var.vpc_module_enabled ? 1 : 0
  vpc_id = var.vpc_id
  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.0.id
  }
  tags = merge(
    {
      Name = "${var.name}-priv-rt"
    },
    var.tags,
  )
}

################################
# Route Table subnet association
################################
resource "aws_route_table_association" "public" {
  count = var.vpc_module_enabled && length(var.pub_subnet_cidr) > 0 ? length(var.pub_subnet_cidr) : 0

  subnet_id      = element(aws_subnet.pub_sub.*.id, count.index)
  route_table_id = aws_route_table.public_rt.0.id
}

resource "aws_route_table_association" "private" {
  count = var.vpc_module_enabled && length(var.priv_subnet_cidr) > 0 ? length(var.priv_subnet_cidr) : 0

  subnet_id      = element(aws_subnet.priv_sub.*.id, count.index)
  route_table_id = aws_route_table.private_rt.0.id
}