resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "EKS-VPC"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "eks-node-subnet" {
  count             = 3
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.100.${count.index}.0/24"
  vpc_id            = aws_vpc.eks-vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-igw"
  }

}

resource "aws_route_table" "eks-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }

}

resource "aws_route_table_association" "eks-rt-association" {
  count          = 3
  subnet_id      = aws_subnet.eks-node-subnet.*.id[count.index]
  route_table_id = aws_route_table.eks-rt.id
}

# master security groups
resource "aws_security_group" "eks-cluster-sg" {
  name        = "eks-cluster-sg"
  description = "EKS Cluster security group"
  vpc_id      = aws_vpc.eks-vpc.id

  ingress {
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port  = 1025
    to_port    = 65535
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}



