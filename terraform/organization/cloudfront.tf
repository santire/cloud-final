module "cloudfront" {

  source          = "../modules/cloudfront"
  images_bucket_arn = module.s3["images"].bucket_arn
  images_bucket_id = module.s3["images"].bucket_id
  thumbs_bucket_arn = module.s3["thumbnails"].bucket_arn
  thumbs_bucket_id = module.s3["thumbnails"].bucket_id
  domain_name     = module.s3["website"].website_endpoint
  images_domain_name = module.s3["images"].bucket_regional_domain_name
  thumbs_domain_name = module.s3["thumbnails"].bucket_regional_domain_name
  api_domain_name = ""

#   api_domain_name = module.apigw.domain_name
 

  depends_on = [
    module.s3,
    # module.apigw
  ]
}