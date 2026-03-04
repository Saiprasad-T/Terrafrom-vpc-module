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

/* resource "aws_subnet" "public" {
  count = length(var.pub_sub_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub_cidr(count.index)

  tags = {
    Name = "Main"
  }
} */