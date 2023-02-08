resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "cloud"
}

data "aws_iam_policy_document" "images_bucket_policy" {
  policy_id = "ImagesBucketReadPolicy"
  version   = "2008-10-17"

 # Allow CloudFront to access objects inside the bucket
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.images_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [var.images_bucket_arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

 
}

data "aws_iam_policy_document" "thumbs_bucket_policy" {
  policy_id = "ThumbsBucketReadPolicy"
  version   = "2008-10-17"

 # Allow CloudFront to access objects inside the bucket
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.thumbs_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [var.thumbs_bucket_arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

 
}


resource "aws_s3_bucket_policy" "read_images_bucket" {
  bucket = var.images_bucket_id
  policy = data.aws_iam_policy_document.images_bucket_policy.json
}
resource "aws_s3_bucket_policy" "read_thumbs_bucket" {
  bucket = var.thumbs_bucket_id
  policy = data.aws_iam_policy_document.thumbs_bucket_policy.json
}

resource "aws_cloudfront_distribution" "s3" {
  origin {

    domain_name = var.domain_name
    origin_id   = "S3_website"
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {

    domain_name = var.images_domain_name
    origin_id   = "S3_images"
    
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  origin {

    domain_name = var.thumbs_domain_name
    origin_id   = "S3_thumbnails"
    
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

#   origin {

#     domain_name = var.api_domain_name
#     origin_id   = local.api_origin_id
#     origin_path = "/api"

#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "https-only"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }


  enabled = true

  default_root_object = "index.html"
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3_images"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
   ordered_cache_behavior {
    path_pattern     = "/thumbnails/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3_thumbnails"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3_website"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
