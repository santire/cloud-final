data "aws_iam_policy_document" "bucket_policy" {
  policy_id = "PolicyForCloudFrontPrivateContent"
  version   = "2008-10-17"

  statement {
    principals {
      type        = "AWS"
      identifiers = [var.lab_role]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }

  # Allow CloudFront to access objects inside the bucket
  statement {
    sid = "AllowCloudFrontServicePrincipal"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${module.static_website_bucket.s3_bucket_arn}/*"]

    condition {
      test      = "StringEquals"
      variable  = "AWS:SourceArn"
      values    = [module.cdn.cloudfront_distribution_arn]
    }
  }

  # statement {
  #   sid = "3"

  #   principals {
  #     type        = "AWS"
  #     identifiers = ["arn:aws:iam::cloudfront:user/*"]
  #   }

  #   actions   = ["s3:GetObject"]
  #   resources = ["${module.static_website_bucket.s3_bucket_arn}/*"]
  # }
}

# Need this to avoid dependecy cycle between:
#   bucket -> cloudfront -> bucket policy -> bucket
resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  bucket = module.static_website_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_object" "index" {
  key    = "index.html"
  bucket = module.static_website_bucket.s3_bucket_id
  source = "src/static/index.html"
  
  content_type = "text/html"
}

module "static_website_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name

  force_destroy       = true
  request_payer       = "BucketOwner"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  acl = "private" # "acl" conflicts with "grant" and "owner"

  versioning = {
    status     = true
    mfa_delete = false
  }

  website = {
    index_document = "index.html"
    error_document = "index.html" # Error handled in-app
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        # We could configure an AWS managed key with kms, keeping it free-tier
        # kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "AES256"
      }
    }
  }

  # TODO: configure later as it will need to hit API gateway
  # cors_rule = [
  #   {
  #     allowed_methods = ["PUT", "POST"]
  #     allowed_origins = ["https://modules.tf", "https://terraform-aws-modules.modules.tf"]
  #     allowed_headers = ["*"]
  #     expose_headers  = ["ETag"]
  #     max_age_seconds = 3000
  #     }, {
  #     allowed_methods = ["PUT"]
  #     allowed_origins = ["https://example.com"]
  #     allowed_headers = ["*"]
  #     expose_headers  = ["ETag"]
  #     max_age_seconds = 3000
  #   }
  # ]
}
