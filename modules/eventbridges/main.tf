module "eventbridge_dns" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false

  rules = {
    ec2_run = {
      description   = "EC2InstanceRunning"
      event_pattern = jsonencode({
            "source": ["aws.ec2"],
            "detail-type": ["EC2 Instance State-change Notification"],
            "detail": {
                "state": ["running"],
                "instance-id": ["${var.instance_id}"]
            }
        })
    }
  }

  targets = {
    ec2_run = [
      {
        name = "Invoke lambda_dns"
        arn  = var.lambda_dns_arn
      }
    ]
  }
}

module "eventbridge_autostop" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false

  rules = {
    stop = {
      schedule_expression = "cron(*/30 * * * * *)"
    }
  }

  targets = {
    stop = [
      {
        name = "Invoke lambda_autostop"
        arn  = var.lambda_autostop_arn
      }
    ]
  }
}