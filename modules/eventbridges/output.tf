output "eventbridge_dns_arn" {
    value = module.eventbridge_dns.eventbridge_rule_arns.ec2_run
}

output "eventbridge_autostop_arn" {
    value = module.eventbridge_autostop.eventbridge_rule_arns.stop
}