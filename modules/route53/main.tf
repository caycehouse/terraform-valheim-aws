module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.hosted_zone_id

  records = [
    {
      name    = "valheim"
      type    = "A"
      ttl     = 60
      records = [
        var.instance_ip,
      ]
    },
  ]
}