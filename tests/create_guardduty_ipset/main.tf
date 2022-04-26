module "guardduty_ipset" {
  source = "../../"

  enable = true

  ipset = {
    name     = "MyIpset"
    activate = true
    format   = "TXT"
    location = "https://s3.amazonaws.com/${aws_s3_object.ipSet.bucket}/${aws_s3_object.ipSet.key}"
    tags = {
      environment = "testing"
    }
  }
}

resource "random_id" "name" {
  byte_length = 6
  prefix      = "tardigrade-s3-bucket-"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = random_id.name.hex
  force_destroy = true
  tags = {
    environment = "testing"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "ipSet" {
  acl     = "public-read"
  content = "10.0.0.0/8\n"
  bucket  = aws_s3_bucket.bucket.id
  key     = "MyIpSet"
}
