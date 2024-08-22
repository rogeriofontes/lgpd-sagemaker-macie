#resource "aws_macie2_account" "macie" {
  #finding_publishing_frequency = "FIFTEEN_MINUTES"
#}

resource "aws_macie2_classification_job" "example" {
  job_type = "ONE_TIME"
  name     = "example-macie-job"
  s3_job_definition {
    bucket_definitions {
      account_id = var.aws_account_id
      buckets    = ["train-bucket-udi-meetup"]
    }
    scoping {
      includes {
        and {
          simple_scope_term {
            comparator = "EQ"
            key        = "OBJECT_EXTENSION"
            values     = ["csv"]
          }
        }
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "macie_log_group" {
  name = "/aws/macie/classification_jobs"
  retention_in_days = 30
}
