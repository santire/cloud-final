# --------------------------------------------------------------------
# Amazon S3 buckets output
# --------------------------------------------------------------------

output "bucket_id" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  value       = aws_s3_bucket.this.arn
}


output "website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website."
  value       = var.index_document != null ? aws_s3_bucket_website_configuration.this[0].website_endpoint : "" 
}

output "bucket_regional_domain_name" {
  description = "Regional domain name"
  value = aws_s3_bucket.this.bucket_regional_domain_name
}