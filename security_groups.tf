# CIDR ranges for EC2 connect
data "aws_ip_ranges" "ec2-connect-ip" {
  regions  = [var.region]
  services = ["EC2_INSTANCE_CONNECT"]
}

resource "aws_security_group" "jenkins-ctrl-sg" {
  name        = "jenkins-ctrl-sg"
  description = "SG for Jenkins controller"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow 22 from EC2 connect"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = data.aws_ip_ranges.ec2-connect-ip.cidr_blocks
  }

  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins-worker-sg" {
  name        = "jenkins-worker-sg"
  description = "SG for Jenkins worker"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow 22 from jenkins-ctrl-sg"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins-ctrl-sg.id]
  }

  egress {
    description = "Allow outbound connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_lb_sg" {
  name        = "app_lb_sg"
  description = "SG for Petclinic Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_server_sg" {
  name        = "app_server_sg"
  description = "SG for Petclinic app server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow 22 from jenkins worker"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins-worker-sg.id]
  }

  ingress {
    description = "Allow 80 from ALB SG and Jenkins worker SG"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.app_lb_sg.id,
      aws_security_group.jenkins-worker-sg.id,
    ]
  }

  ingress {
    description = "Allow 8080 from jenkin worker SG"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [
      aws_security_group.jenkins-worker-sg.id,
    ]
  }

  egress {
    description = "Allow outbound connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "SG for Petclinic RDS DB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow access to MYSQL from app SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_server_sg.id]
  }
}