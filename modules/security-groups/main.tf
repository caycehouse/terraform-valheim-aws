module "valheim_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "valheim"
  description = "Security group for valheim with custom ports open within VPC"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
        from_port   = 2456
        to_port     = 2458
        protocol    = "udp"
        description = "Valheim"
        cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.your_ip
    },
  ]

  egress_with_cidr_blocks = [
    {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        description = "Allow all egress"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
}
