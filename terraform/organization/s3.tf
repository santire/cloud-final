module "static_site" {
  source = "../modules/static_website"

  bucket_name = "jsuarezb.tpfinal.g1.cloud.itba.edu.ar"
  lab_role    = local.lab_role
}