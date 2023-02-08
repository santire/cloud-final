locals {
    vpc = {
        name = "main-vpc"
        cidr = "10.0.0.0/16"

        azs             = ["us-east-1a", "us-east-1b"]
        private_subnets = ["10.0.2.0/24", "10.0.3.0/24"]

        enable_nat_gateway = false
        enable_vpn_gateway = false
    }

    lab_role = "arn:aws:iam::139927629559:role/LabRole"

  # S3
  bucket_name = "2022c2-g1-cloud-itba-edu-ar"
  path        = "../resources"
  region      = "us-east-1"

  s3 = {

    images = {
      bucket_name = "${local.bucket_name}-images"
      objects = merge([for file in fileset("${local.path}/test-images", "*.jpg") :
        { "${file}" = {
          source       = "test-images/${file}"
          etag         = filemd5("${local.path}/test-images/${file}")
          content_type = "image/jpeg"

          }

        }
      ]...)

    }

    thumbnails = {
      bucket_name = "${local.bucket_name}-thumbnails"
    }

    # 1 - Website
    website = {
      bucket_name = local.bucket_name
      objects = merge([for file in fileset("${local.path}/static-site", "**/*.*") :
        { "${file}" = {
          source       = "static-site/${file}"
          etag         = filemd5("${local.path}/static-site/${file}")
          content_type = lookup(local.mime_types, regex("\\.[^.]+$", file), null)

        } }
      ]...)

      public_read_policy = true
      index_document     = "index.html"
      error_document     = "index.html"

    }

    # 2 - WWW Website
    www-website = {
      bucket_name              = "www.${local.bucket_name}"
      redirect_all_requests_to = "${local.bucket_name}.s3-website-${local.region}.amazonaws.com"

      public_read_policy = true
    }

    # 3 - Logs
    logs = {
      bucket_name = "${local.bucket_name}-logs"
    }
  }

  mime_types = {
    ".css" : "text/css",
    ".html" : "text/html",
    ".js" : "text/javascript"
  }
}