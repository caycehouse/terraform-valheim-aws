resource "aws_ebs_volume" "valheim_ebs" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type = var.volume_type
  tags = {
    valheimdlmsnapshotpolicyHourly = "Yes"
    valheimdlmsnapshotpolicyDaily = "Yes"
  }
}

resource "aws_dlm_lifecycle_policy" "valheim_hourly_dlm" {
  description        = "Valheim HourlyDLM"
  execution_role_arn = var.dlm_iam
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "1 day of hourly snapshots"

      create_rule {
        interval      = 1
        interval_unit = "HOURS"
        times         = ["20:00"]
      }

      retain_rule {
        count = 24
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }
    }

    target_tags = {
      valheimdlmsnapshotpolicyHourly = "Yes"
    }
  }
}

resource "aws_dlm_lifecycle_policy" "valheim_daily_dlm" {
  description        = "Valheim DailyDLM"
  execution_role_arn = var.dlm_iam
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "1 week of daily snapshots"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["20:00"]
      }

      retain_rule {
        count = 7
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }
    }

    target_tags = {
      valheimdlmsnapshotpolicyDaily = "Yes"
    }
  }
}
