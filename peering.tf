#creating vnet peering with default vpc
resource "aws_vpc_peering_connection" "main" {
  count = var.is_peering_requried ? 1 : 0
  peer_vpc_id   = data.aws_route_table.default
  vpc_id        = aws_vpc.main.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = merge (
      local.common_tags,
    {
         Name = "${var.project}-${var.environment}-peering"
    },
    )
    }

#creating public peering connection

resource "aws_route" "requester_pub_route" {
  count = var.is_peering_requried ? 1 : 0
  route_table_id            = aws_route_table.public_rtb.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block.id
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

#creating private peering connection

resource "aws_route" "requester_pri_route" {
  count = var.is_peering_requried ? 1 : 0
  route_table_id            = aws_route_table.private_rtb.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block.id
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

#creating DB peering connection
resource "aws_route" "requester_db_route" {
  count = var.is_peering_requried ? 1 : 0
  route_table_id            = aws_route_table.database_rtb.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block.id
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default" {
  count = var.is_peering_requried ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}