 //VPC
resource "aws_vpc" "demoVpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "demoVpc"
  }
}
 //SUBNETS
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.demoVpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true" // Makes this a public subnet
  tags = {
    Name : "public_subnet"
  }
}

//GW
resource "aws_internet_gateway" "test2-igw" {
  vpc_id = aws_vpc.demoVpc.id
}


