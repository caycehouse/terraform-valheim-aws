module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.0.0"

  zone_id = var.hosted_zone_id

  records = [
    {
      name    = "vh"
      type    = "A"
      ttl     = 60
      records = [
        var.instance_ip,
      ]
    },
  ]
}