//Created VPC for a sepearate application virtual private network
//instead of using default one, creating seprate VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "AmpleVPC"
  }
}

resource "aws_subnet" "SubnetA" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az-1
  map_public_ip_on_launch = true

  tags = {
    "Name" = "SubnetA"
  }
}

resource "aws_subnet" "SubnetB" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.az-2
  map_public_ip_on_launch = true

  tags = {
    "Name" = "SubnetB"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    "Name" = "IGW"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = var.CIDR_anywhere
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "rt"
  }

}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.SubnetA.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.SubnetB.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "Sg_1"{
  name        = "websg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description      = "HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.CIDR_anywhere]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.CIDR_anywhere]

  }

  tags = {
    Name = "WebSecurity1"
  }
}

// Need a webserver to host application

resource "aws_instance" "webserver1" {
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = var.az-1
  vpc_security_group_ids = [aws_security_group.Sg_1.id]
  subnet_id = aws_subnet.SubnetA.id
  user_data = file(var.linux_script)

  tags = {
    Name = "Webserver1"
  }
}

output "ip" {
  value = aws_instance.webserver1.arn
}


