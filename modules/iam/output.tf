output "valheim_dlm_iam" {
    value = aws_iam_role.dlm_lifecycle_role.arn
}

output "valheim_lambda_dns_iam" {
    value = aws_iam_role.valheim_iam_for_dns_lambda.arn
}

output "valheim_lambda_startstop_iam" {
    value = aws_iam_role.valheim_iam_for_startstop_lambda.arn
}