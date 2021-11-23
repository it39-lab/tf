provider "aws" {
  profile = "default"
  region = "us-east-2"
}
resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"
}
resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2c"
}

resource "aws_network_interface" "int1" {
  subnet_id = aws_subnet.public.id
  private_ips = ["10.0.1.10"]
  security_groups = [aws_security_group.web-sg.id]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "igw"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt"
  }
  
}
resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
  
}


resource "aws_security_group" "web-sg" {
  name = "WebSG"
  vpc_id = aws_vpc.my-vpc.id
  ingress {
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  
}
resource "aws_instance" "web-server-1" {
  ami = "ami-0d718c3d715cec4a7"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = file("apache.sh")
  subnet_id = aws_subnet.public.id
  depends_on = [aws_internet_gateway.igw]
  associate_public_ip_address = true
}
/*
resource "aws_instance" "web-server-2" {
  ami = "ami-0d718c3d715cec4a7"
  instance_type = "t2.micro"
//  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = file("apache2.sh")
//  subnet_id = "subnet-0c3f010b96c29b822"
  network_interface {
    network_interface_id = aws_network_interface.int1.id
    device_index = 0
//    depends_on = [aws_internet_gateway.igw]
  }
}
*/


/*
resource "aws_lb" "web-lb" {
  name = "web-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.web-sg.id]
  subnets = aws_subnet.public.*.id
  
}
resource "aws_lb_target_group" "web-tg" {
  name = "web-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_alb_target_group_attachment" "tg-att-1" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id = aws_instance.web-server-1.id
  port = 80 
}
resource "aws_alb_target_group_attachment" "tg-att-2" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id = aws_instance.web-server-2.id
  port = 80 
}
*/