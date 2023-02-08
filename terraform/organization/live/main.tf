locals {
  lambdas_configuration = [
    {
      function_name = "list_cakes",
      description   = "List all cakes",
      handler       = "index.lambda_handler",
      runtime       = "python3.8"

      source_path = "${path.module}/src/list_cakes"
    },
    {
      function_name = "delete_cake",
      description   = "Delete a cake",
      handler       = "index.lambda_handler",
      runtime       = "python3.8"

      source_path = "${path.module}/src/list_cakes"
    },
    {
      function_name = "create_cake",
      description   = "Create a new cake",
      handler       = "index.lambda_handler",
      runtime       = "python3.8"

      source_path = "${path.module}/src/list_cakes"
    },
    {
      function_name = "create_like",
      description   = "Create a new like for a cake",
      handler       = "index.lambda_handler",
      runtime       = "python3.8"

      source_path = "${path.module}/src/list_cakes"
    },
    {
      function_name = "watermark_photo_cake",
      description   = "Watermark a cake photo",
      handler       = "index.lambda_handler",
      runtime       = "python3.8"

      source_path = "${path.module}/src/list_cakes"
    },
    {
      function_name = "select_winner",
      description   = "Select and notify the winner",
      handler       = "index.lambda_handler",
      runtime       = "python3.8"

      source_path = "${path.module}/src/list_cakes"
    }
  ]

  lab_role = "arn:aws:iam::764691583685:role/LabRole"
}

module "lambdas" {
  source = "../../modules/lambdas"

  lambdas                = local.lambdas_configuration
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  lambda_role = local.lab_role

  depends_on = [
    module.vpc_endpoints
  ]
}

module "static_site" {
  source = "../../modules/static_website"

  bucket_name = "jsuarezb.tp3.g1.cloud.itba.edu.ar"
  lab_role    = local.lab_role
}
