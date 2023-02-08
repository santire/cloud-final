
module "api_gateway" {
  source = "../modules/api_gateway"

  user_pool_arn = module.cognito.user_pool_arn
  lambdas = {
    list_recipes = {
      lambda_function_name = "arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-get_recipes"
      lambda_function_invoke_arn = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-get_recipes/invocations"
    },
    get_recipe = {
      lambda_function_name = "arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-get_recipe"
      lambda_function_invoke_arn = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-get_recipe/invocations"
    },
    create_recipe = {
      lambda_function_name = "arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-create_recipe"
      lambda_function_invoke_arn = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-create_recipe/invocations"
    },
    create_like = {
      lambda_function_name = "arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-like_recipe"
      lambda_function_invoke_arn = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-like_recipe/invocations"
    } 
  }
}

module "cognito" {
  source = "../modules/cognito"

  backend_callback_url = module.api_gateway.invoke_url
}

module "rds" {
  source = "../modules/rds"

  pg_username = "postgres"
  pg_password = "postgres"
  pg_port     = 5432
  pg_database = "postgres"
  name        = "cloud"

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.public_subnets
  lambdas_security_group_id = module.lambdas_security_group_id.security_group_id
}