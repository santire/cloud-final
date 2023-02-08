resource "aws_api_gateway_rest_api" "hornero" {
  name  = "Hornero"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_deployment" "hornero" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.hornero.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "production" {
  deployment_id = aws_api_gateway_deployment.hornero.id
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  stage_name    = "production"
}


resource "aws_api_gateway_authorizer" "hornero_cognito" {
  name        = "hornero_cognito"
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  type        = "COGNITO_USER_POOLS"
  
  provider_arns = [var.user_pool_arn]
}

## sign up callback ##

resource "aws_api_gateway_resource" "sign_up" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  parent_id   = aws_api_gateway_rest_api.hornero.root_resource_id
  path_part   = "sign_up"
}

resource "aws_api_gateway_method" "list_sign_up" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.sign_up.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "list_sign_up" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.sign_up.id
  http_method             = aws_api_gateway_method.list_sign_up.http_method
  request_parameters      = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY" # NOTE: we could try with AWS_PROXY too
  uri                     = var.lambdas.sign_up.lambda_function_invoke_arn
}

resource "aws_lambda_permission" "list_sign_up" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.sign_up.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}


### recipes ###

resource "aws_api_gateway_resource" "recipes" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  parent_id   = aws_api_gateway_rest_api.hornero.root_resource_id
  path_part   = "recipes"
}

### GET

resource "aws_api_gateway_method" "list_recipes" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.recipes.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
}

resource "aws_api_gateway_integration" "list_recipes" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.recipes.id
  http_method             = aws_api_gateway_method.list_recipes.http_method
  request_parameters      = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY" # NOTE: we could try with AWS_PROXY too
  uri                     = var.lambdas.list_recipes.lambda_function_invoke_arn
}

resource "aws_lambda_permission" "list_recipes" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.list_recipes.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "recipes_200" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.recipes.id
  http_method = aws_api_gateway_method.list_recipes.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "recipes_200" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.recipes.id
  http_method = aws_api_gateway_method.list_recipes.http_method
  status_code = aws_api_gateway_method_response.recipes_200.status_code
}


### DELETE

# resource "aws_api_gateway_method" "delete_recipe" {
#   rest_api_id   = aws_api_gateway_rest_api.hornero.id
#   resource_id   = aws_api_gateway_resource.recipes.id
#   http_method   = "DELETE"
#   authorization = "COGNITO_USER_POOLS"
#   authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
# }

# resource "aws_api_gateway_integration" "delete_recipe" {
#   rest_api_id             = aws_api_gateway_rest_api.hornero.id
#   resource_id             = aws_api_gateway_resource.recipes.id
#   http_method             = aws_api_gateway_method.delete_recipe.http_method
#   request_parameters      = {}
#   request_templates       = {}
#   content_handling        = "CONVERT_TO_TEXT"
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY" # NOTE: we could try with AWS_PROXY too
#   uri                     = var.lambdas["delete_recipe"].lambda_function_invoke_arn
# }

# resource "aws_lambda_permission" "delete_recipe" {
#   statement_id  = "AllowHorneroAPIInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = var.lambdas["delete_recipe"].lambda_function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
# }

# resource "aws_api_gateway_method_response" "recipes_204" {
#   rest_api_id = aws_api_gateway_rest_api.hornero.id
#   resource_id = aws_api_gateway_resource.recipes.id
#   http_method = aws_api_gateway_method.delete_recipe.http_method
#   status_code = "204"

#   response_models = {
#     "application/json" = "Empty"
#   }
# }

# resource "aws_api_gateway_integration_response" "recipes_204" {
#   rest_api_id = aws_api_gateway_rest_api.hornero.id
#   resource_id = aws_api_gateway_resource.recipes.id
#   http_method = aws_api_gateway_method.delete_recipe.http_method
#   status_code = aws_api_gateway_method_response.recipes_204.status_code
# }

### CREATE

resource "aws_api_gateway_method" "create_recipe" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.recipes.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
}

resource "aws_api_gateway_integration" "create_recipe" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.recipes.id
  http_method             = aws_api_gateway_method.create_recipe.http_method
  request_parameters      = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY" # NOTE: we could try with AWS_PROXY too
  uri                     = var.lambdas.create_recipe.lambda_function_invoke_arn
}

resource "aws_lambda_permission" "create_recipe" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.create_recipe.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}


### Likes ###

resource "aws_api_gateway_resource" "likes" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  parent_id   = aws_api_gateway_rest_api.hornero.root_resource_id
  path_part   = "likes"
}

### POST

resource "aws_api_gateway_method" "create_like" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.likes.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
}

resource "aws_api_gateway_integration" "create_like" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.likes.id
  http_method             = aws_api_gateway_method.create_like.http_method
  request_parameters      = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY" # NOTE: we could try with AWS_PROXY too
  uri                     = var.lambdas.create_like.lambda_function_invoke_arn

  request_templates = {
    "application/json" = file("${path.module}/application_json_template.txt")
  }
}

resource "aws_lambda_permission" "create_like" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.create_like.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "likes_201" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.likes.id
  http_method = aws_api_gateway_method.create_like.http_method
  status_code = "201"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "likes_201" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.likes.id
  http_method = aws_api_gateway_method.create_like.http_method
  status_code = aws_api_gateway_method_response.likes_201.status_code
}

### DELETE

resource "aws_api_gateway_method" "remove_like" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.likes.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
}

resource "aws_api_gateway_integration" "remove_like" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.likes.id
  http_method             = aws_api_gateway_method.remove_like.http_method
  request_parameters      = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY" # NOTE: we could try with AWS_PROXY too
  uri                     = var.lambdas.remove_like.lambda_function_invoke_arn

  request_templates = {
    "application/json" = file("${path.module}/application_json_template.txt")
  }
}

resource "aws_lambda_permission" "remove_like" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.remove_like.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "dislikes_204" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.likes.id
  http_method = aws_api_gateway_method.remove_like.http_method
  status_code = "204"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "dislikes_204" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.likes.id
  http_method = aws_api_gateway_method.remove_like.http_method
  status_code = aws_api_gateway_method_response.dislikes_204.status_code
}