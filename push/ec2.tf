//LB
resource "aws_lb" "load_balancer_dai" {
  name               = var.load_balancer_dai_name
  internal           = false
  load_balancer_type = var.load_balancer_dai_application
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = aws_subnet.public_subnet.id

  tags = {
    Environment = var.load_balancer_dai_environment
  }
}
//para el destino de ec2
resource "aws_lb_target_group" "ec2_target_group" {
  name     = "ec2_target_group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demoVpc.id
}

// para el ALB
resource "aws_lb_target_group" "alb-target_group" {
  name        = "alb-target_group"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id   = aws_vpc.demoVpc.id
}

//listener
resource "aws_lb_listener" "listener_dai" {
  load_balancer_arn = aws_lb.load_balancer_dai.arn
  port              = var.listener_dai_port
  protocol          = var.listener_dai_protocol

  default_action {
    type             = var.listener_dai_type
    target_group_arn = aws_lb_target_group.ec2_target_group.arn //?
  }
}


// EC2 instances
resource "aws_key_pair" "my-key-pair" {
  key_name   = var.my-key-pair-name
  public_key = var.my-key-pair-public_key
}

resource "aws_instance" "nginx_server" {
  ami           = var.nginx_server_ami 
  instance_type = var.nginx_server_instance-type
  key_name      = var.my-key-pair-name
  tags = {
    Name = var.nginx_server_ngnix_name
  }
}

resource "aws_instance" "apache_server" {
  ami           = var.apache_server_ami
  instance_type = var.apache_server_instance-type
  key_name      = var.my-key-pair-name
  //security_group = aws_security_group.alb_security_group --FALLA
  
      tags = {
    Name = var.apache_server_apache_name
  }
}

//SECURITY GROUP
resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "Security Group for ALB"
  //vpc_id      = aws_vpc.demoVpc.id
}

resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Security Group for EC2"
}



