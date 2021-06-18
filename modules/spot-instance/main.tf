data "aws_region" "current" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_spot_instance_request" "valheim_instance" {
    ami = data.aws_ami.amazon_linux_2.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_groups
    key_name = var.key_name
    wait_for_fulfillment = true
    spot_type = "persistent"
    secondary_private_ips = []
    user_data = var.user_data
    iam_instance_profile = var.iam_instance_profile
    instance_interruption_behaviour = "stop"

    tags = {
      Name = "Valheim"
    }
}

resource "aws_volume_attachment" "valheim_ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = var.volume_id
  instance_id = aws_spot_instance_request.valheim_instance.spot_instance_id
}

resource "aws_ec2_tag" "valheim_tag" {
  resource_id = aws_spot_instance_request.valheim_instance.spot_instance_id

  key      = "Name"
  value    = "Valheim"
}