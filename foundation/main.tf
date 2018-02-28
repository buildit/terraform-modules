data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-vpc"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet_a_cidr_block}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-subnet-public-a"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_subnet" "subnet_public_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet_b_cidr_block}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-subnet-public-b"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_subnet" "subnet_private_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_subnet_a_cidr_block}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = false

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-subnet-private-a"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_subnet" "subnet_private_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_subnet_b_cidr_block}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = false

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-subnet-private-b"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-internet-gateway"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_eip" "eip_nat_a" {
  vpc        = true
  depends_on = ["aws_internet_gateway.internet_gateway"]

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-eip-nat-a"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_eip" "eip_nat_b" {
  vpc        = true
  depends_on = ["aws_internet_gateway.internet_gateway"]

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-eip-nat-b"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = "${aws_eip.eip_nat_a.id}"
  subnet_id     = "${aws_subnet.subnet_public_a.id}"
  depends_on    = ["aws_internet_gateway.internet_gateway"]

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-nat-a"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = "${aws_eip.eip_nat_b.id}"
  subnet_id     = "${aws_subnet.subnet_public_b.id}"
  depends_on    = ["aws_internet_gateway.internet_gateway"]

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-nat-b"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route_table" "private_route_table_a" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-private-route-table-a"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-private-route-table-b"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route" "private_route_a" {
  route_table_id         = "${aws_route_table.private_route_table_a.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_a.id}"
}

resource "aws_route" "private_route_b" {
  route_table_id         = "${aws_route_table.private_route_table_b.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_b.id}"
}

# Associate subnet public subnet a to public route table
resource "aws_route_table_association" "subnet_public_a_association" {
  subnet_id      = "${aws_subnet.subnet_public_a.id}"
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
}

# Associate subnet public subnet b to public route table
resource "aws_route_table_association" "subnet_public_b_association" {
  subnet_id      = "${aws_subnet.subnet_public_b.id}"
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
}

# Associate subnet private subnet a to private route table
resource "aws_route_table_association" "subnet_private_a_association" {
  subnet_id      = "${aws_subnet.subnet_private_a.id}"
  route_table_id = "${aws_route_table.private_route_table_a.id}"
}

# Associate subnet private subnet b to private route table
resource "aws_route_table_association" "subnet_private_b_association" {
  subnet_id      = "${aws_subnet.subnet_private_b.id}"
  route_table_id = "${aws_route_table.private_route_table_b.id}"
}

resource "aws_security_group" "lb_sg" {
  name = "${var.owner}-${var.project}-${var.environment}-foundation-lb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_load_balancer" {
  name            = "${var.owner}-${var.project}-${var.environment}-foundation-lb"
  internal        = false
  security_groups = ["${aws_security_group.lb_sg.id}"]
  subnets         = ["${aws_subnet.subnet_public_a.id}","${aws_subnet.subnet_public_b.id}"]

  enable_deletion_protection = false

  tags {
    "Name"        = "${var.owner}-${var.project}-${var.environment}-foundation-lb"
    "Owner"       = "${var.owner}"
    "Project"     = "${var.project}"
    "Environment" = "${var.environment}"
  }
}
