resource "aws_iam_role" "dlm_lifecycle_role" {
  name = "valheim_dlm_lifecycle_role"
  description = "Allow Data Lifecycle Manager to create and manage AWS resources on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dlm.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dlm_lifecycle_policy_attachment" {
  role = aws_iam_role.dlm_lifecycle_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataLifecycleManagerServiceRole"
}

resource "aws_iam_role" "valheim_iam_for_dns_lambda" {
  name = "valheim_iam_for_dns_lambda"
  description = "Allows Lambda functions to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valheim_dns_lambda_policy" {
  name = "valheim_dns_lambda_policy"
  role = aws_iam_role.valheim_iam_for_dns_lambda.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "valheim_iam_for_startstop_lambda" {
  name = "valheim_iam_for_startstop_lambda"
  description = "Allows Lambda functions to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_instance" "valheim_instance" {
  instance_id = var.instance_id
}

resource "aws_iam_role_policy" "valheim_startstop_lambda_policy" {
  name = "valheim_startstop_lambda_policy"
  role = aws_iam_role.valheim_iam_for_startstop_lambda.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "${data.aws_instance.valheim_instance.arn}"
        }
    ]
}
EOF
}