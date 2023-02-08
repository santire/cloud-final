# 1 - S3 bucket
resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  object_lock_enabled = false
}

# 2 - Bucket policy
resource "aws_s3_bucket_policy" "this" {
  count = var.public_read_policy ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_public_access_block" "gitbook" {
 count = var.public_read_policy ? 0:1
  bucket = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# 3 - Access Control List
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.bucket_acl
}

# 4 - Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 5 - Website configuration
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.index_document == null && var.redirect_all_requests_to == null ? 0 : 1
  bucket = aws_s3_bucket.this.id

  dynamic "redirect_all_requests_to" {
    for_each = var.redirect_all_requests_to != null ? [var.redirect_all_requests_to] : []
    content {
      protocol  = "http"
      host_name = var.redirect_all_requests_to
    }
  }

  dynamic "index_document" {
    for_each = var.redirect_all_requests_to == null && var.index_document != null ? [var.index_document] : []
    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = var.redirect_all_requests_to == null && var.error_document != null ? [var.error_document] : var.index_document != null ? [var.index_document] : []
    content {
      key = error_document.value
    }
  }
}

# 6 - Upload objects
resource "aws_s3_object" "this" {
  for_each = try(var.objects, {})

  bucket        = aws_s3_bucket.this.id
  key           = try(each.key, basename(each.value.source))                                # remote path
  source        = try(each.value.rendered, format("../resources/%s", each.value.source)) # where is the file located
  etag          = try(each.value.etag, null)
  content_type  = each.value.content_type
  storage_class = try(each.value.tier, "STANDARD")
}
