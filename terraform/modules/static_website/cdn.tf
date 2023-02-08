resource "aws_cloudfront_origin_access_control" "static_website" {
  name                              = "static_website"
  description                       = "OAC policy for accessing S3 static website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  comment             = "CDN to support app"
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = true

  origin = {
    static_website = {
      domain_name              = module.static_website_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.static_website.id
    }
  }

  default_cache_behavior = {
    target_origin_id           = "static_website"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "*"
      target_origin_id       = "static_website"
      viewer_protocol_policy = "allow-all" # NOTE: inside Labs it seems like there's no way to use ACM

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  custom_error_response = [
    {
      error_caching_min_ttl = 0
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
    },
    {
      error_caching_min_ttl = 0
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]

}
