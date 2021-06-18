data "aws_instance" "valheim_instance" {
  instance_id = var.instance_id
}

module "lambda_dns" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.4.0"

  function_name = "valheim_dns"
  description = "Automatically updates route53 dns entryfor Valheim on instance start"
  handler = "index.handler"
  runtime = "nodejs14.x"

  source_path = "${path.module}/valheim-dns"

  allowed_triggers = {
    InstanceRunningRule = {
      principal  = "events.amazonaws.com"
      source_arn = var.eventbridge_dns_arn
    }
  }

  environment_variables = {
    hosted_zone_id = var.hosted_zone_id
    record_name = var.record_name
  }

  attach_policy_json = true
  policy_json        = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "${data.aws_instance.valheim_instance.arn}"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ChangeResourceRecordSets",
      "Resource": "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
    }
  ]
}
EOF
}

module "lambda_start" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.4.0"

  function_name = "valheim_start"
  description = "A start instance function for Valheim"
  handler = "index.handler"
  runtime = "nodejs14.x"

  source_path = "${path.module}/valheim-start"

  environment_variables = {
    instance_id = var.instance_id
  }

  attach_policy_json = true
  policy_json        = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances"
      ],
      "Resource": "${data.aws_instance.valheim_instance.arn}"
    }
  ]
}
EOF
}

module "lambda_autostop" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.4.0"

  function_name = "valheim_autostop"
  description = "An auto-stop function for Valheim"
  handler = "index.handler"
  runtime = "nodejs14.x"

  source_path = "${path.module}/valheim-autostop"

  allowed_triggers = {
    ScheduledRule = {
      principal  = "events.amazonaws.com"
      source_arn = var.eventbridge_autostop_arn
    }
  }

  attach_policy_json = true
  policy_json        = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StopInstances"
      ],
      "Resource": "${data.aws_instance.valheim_instance.arn}"
    }
  ]
}
EOF
}
