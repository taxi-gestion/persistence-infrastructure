# Ephemeral: Open the RDS instance to the internet for data migration
# Get available zones for this account
#data "aws_availability_zones" "available" {
#  state = "available"
#}
#
#resource "aws_route_table" "ephemeral_public" {
#  count = var.open_rds_to_public_internet ? 1 : 0
#
#  vpc_id = var.vpc_id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = var.internet_gateway_id
#  }
#
#  tags = local.tags
#}
#
#resource "aws_subnet" "ephemeral" {
#  count = var.open_rds_to_public_internet ? 1 : 0
#
#  availability_zone       = data.aws_availability_zones.available.names[1]
#  vpc_id                  = var.vpc_id
#  map_public_ip_on_launch = false
#  cidr_block              = "10.0.5.0/24"
#  tags                    = merge(local.tags, { "Name" = "ephemeral" })
#}
#
#resource "aws_route_table_association" "route_association_open_rds" {
#  count          = var.open_rds_to_public_internet ? 1 : 0
#  subnet_id      = aws_subnet.ephemeral[0].id
#  route_table_id = aws_route_table.ephemeral_public[0].id
#}


resource "aws_db_subnet_group" "private_subnets_group" {
  name       = "private-subnets-for-rds"
  subnet_ids = compact(concat(var.private_subnets_ids, var.open_rds_to_public_internet ? var.public_subnets_ids : [""]))
}


resource "aws_security_group" "security_group_for_rds" {
  name        = "security-group-rds"
  description = "Allow traffic from and to the instance"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { "Name" = "security-group-rds" })

  lifecycle {
    # Necessary if changing 'name' or 'name_prefix' properties.
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_incoming_to_database" {
  type              = "ingress"
  description       = "Allow all incoming"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.security_group_for_rds.id
}

resource "aws_security_group_rule" "allow_outgoing_from_database" {
  type              = "egress"
  description       = "Allow all outgoing"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.security_group_for_rds.id
}

