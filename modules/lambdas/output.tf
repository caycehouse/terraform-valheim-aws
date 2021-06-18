output "lambda_dns_arn" {
    value = module.lambda_dns.lambda_function_arn
}

output "lambda_autostop_arn" {
    value = module.lambda_autostop.lambda_function_arn
}