resource "aws_lambda_function" "valheim_dns" {
  filename      = "${path.module}/valheim-dns/function.zip"
  function_name = "valheim_dns"
  role          = var.lambda_dns_iam
  handler       = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/valheim-dns/function.zip")

  runtime = "nodejs14.x"

  environment {
    variables = {
      hosted_zone_id = var.hosted_zone_id
      record_name = var.record_name
    }
  }
}

resource "aws_lambda_function" "valheim_startstop" {
  filename      = "${path.module}/valheim-startstop/function.zip"
  function_name = "valheim_startstop"
  role          = var.lambda_startstop_iam
  handler       = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/valheim-startstop/function.zip")

  runtime = "nodejs14.x"

  environment {
    variables = {
      instance_id = var.instance_id
    }
  }
}

resource "aws_cloudwatch_event_target" "valheim_event_target" {
  arn  = aws_lambda_function.valheim_dns.arn
  rule = aws_cloudwatch_event_rule.valheim_event_rule.id
}

resource "aws_cloudwatch_event_rule" "valheim_event_rule" {
  name = "valheim_instance_start_dns"
  description = "Sets the Route53 DNS entry when the valheim server starts."

event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["running"],
    "instance-id": ["${var.instance_id}"]
  }
}
EOF
}