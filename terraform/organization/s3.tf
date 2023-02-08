# module "static_site" {
#   source = "../modules/static_website"

#   bucket_name = "jsuarezb.tpfinal.g1.cloud.itba.edu.ar"
#   lab_role    = local.lab_role
# }

module "s3" {
  for_each = local.s3
  source   = "../modules/s3-bucket"

  bucket_name              = each.value.bucket_name
  objects                  = try(each.value.objects, {})
  public_read_policy       = try(each.value.public_read_policy, false)
  index_document           = try(each.value.index_document, null)
  error_document           = try(each.value.error_document, null)
  redirect_all_requests_to = try(each.value.redirect_all_requests_to, null)

}
