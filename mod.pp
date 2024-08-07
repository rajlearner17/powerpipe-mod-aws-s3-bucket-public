mod "aws_s3_bucket_public" {
  title = "AWS S3 Buckets Public Access"
  require {
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = "*"
    }
    mod "github.com/turbot/steampipe-mod-aws-insights" {
      version = "*"
    }
  }
}