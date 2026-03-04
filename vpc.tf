#for creating vpc
resource "aws_vpc" "main" {     
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = local.vpc_final_tags
  
}

#for creating internet gateway and association with vpc
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = local.vpc_final_igw_tags
}

#for creating public subnet using count loop

resource "aws_subnet" "public" {
  count = length(var.pub_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags =  merge (
      local.common_tags,
      #roboshop-dev-public-us-east-1a
      {
          Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
      },
      var.pub_sub_tags
  )
}
# creating private subnets

resource "aws_subnet" "private" {
  count = length(var.private_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_sub_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags =  merge (
      local.common_tags,
      #roboshop-dev-public-us-east-1a
      {
          Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
      },
      var.private_sub_tags
  )
}
#creating database subnets
resource "aws_subnet" "database" {
  count = length(var.database_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_sub_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags =  merge (
      local.common_tags,
      #roboshop-dev-public-us-east-1a
      {
          Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
      },
      var.database_sub_tags
  )
}
#creating route tables  #public route
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id

   tags =  merge (
    local.common_tags,
    #roboshop-dev-public-rtb
    {
        Name = "${var.project}-${var.environment}-public-rtb"
    },
    var.public_rtb_tags
  )
}
#creating private route table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id

   tags =  merge (
    local.common_tags,
    #roboshop-dev-private-rtb
    {
        Name = "${var.project}-${var.environment}-private-rtb"
    },
    var.private_rtb_tags
  )
}
#creating database route table
resource "aws_route_table" "database_rtb" {
  vpc_id = aws_vpc.main.id

   tags =  merge (
    local.common_tags,
    #roboshop-dev-database-rtb
    {
        Name = "${var.project}-${var.environment}-database-rtb"
    },
    var.database_rtb_tags
  )
}
#creating routes in public route table
resource "aws_route" "igw_route" {
  route_table_id              = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             =  aws_internet_gateway.main.id
}
#creating elstic_ip
resource "aws_eip" "eip_nat" {
  domain = "vpc"
    tags =  merge (
    local.common_tags,
    #roboshop-dev-eip-for-nat
    {
        Name = "${var.project}-${var.environment}-eip-for-nat"
    },
    var.eip_nat_tags
    )
  }
#creating nat gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public[0].id #creating only in one availability, if it is in 2avz cost will incarese
  tags =  merge (
    local.common_tags,
    #roboshop-dev-nat-gtw
    {
        Name = "${var.project}-${var.environment}-nat-gtw"
    },
    var.nat_gtw_tags
    )
      depends_on = [aws_internet_gateway.main]
}
#creating route on private route table for nat 
resource "aws_route" "pri_nat_route" {
  route_table_id              = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id             =  aws_nat_gateway.main.id
}
#creating route on private route table for nat
resource "aws_route" "db_nat_route" {
  route_table_id              = aws_route_table.database_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id             =  aws_nat_gateway.main.id
}
#associating subnets to route table
resource "aws_route_table_association" "pub_sub_association" {
  count = length(var.pub_sub_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "pri_sub_association" {
  count = length(var.private_sub_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "db_sub_association" {
  count = length(var.database_sub_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database_rtb.id
}
