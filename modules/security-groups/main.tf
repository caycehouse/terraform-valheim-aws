resource "aws_security_group" "valheim_sg" {
  name        = "valheim-sg-01"
  description = "The Security Group for valheim-01"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow anybody to connect to VALHEIM"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description = "Allow SSH from Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
