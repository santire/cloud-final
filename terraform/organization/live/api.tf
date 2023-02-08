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
  
  provider_arns = [
    aws_cognito_user_pool.user_pool.arn
  ]
}

### Cakes ###

resource "aws_api_gateway_resource" "cakes" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  parent_id   = aws_api_gateway_rest_api.hornero.root_resource_id
  path_part   = "cakes"
}

### GET

resource "aws_api_gateway_method" "get_cakes" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.cakes.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
}

resource "aws_api_gateway_integration" "get_cakes" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.cakes.id
  http_method             = aws_api_gateway_method.get_cakes.http_method
  request_parameters      = {}
  request_templates       = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS" # NOTE: we could try with AWS_PROXY too
  uri                     = module.lambdas.created_lambdas["list_cakes"].lambda_function_invoke_arn
}

resource "aws_lambda_permission" "get_cakes" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambdas.created_lambdas["list_cakes"].lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "cakes_200" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.cakes.id
  http_method = aws_api_gateway_method.get_cakes.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "cakes_200" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.cakes.id
  http_method = aws_api_gateway_method.get_cakes.http_method
  status_code = aws_api_gateway_method_response.cakes_200.status_code
}


### DELETE

resource "aws_api_gateway_method" "delete_cake" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.cakes.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
}

resource "aws_api_gateway_integration" "delete_cake" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.cakes.id
  http_method             = aws_api_gateway_method.delete_cake.http_method
  request_parameters      = {}
  request_templates       = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS" # NOTE: we could try with AWS_PROXY too
  uri                     = module.lambdas.created_lambdas["delete_cake"].lambda_function_invoke_arn
}

resource "aws_lambda_permission" "delete_cake" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambdas.created_lambdas["delete_cake"].lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "cakes_204" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.cakes.id
  http_method = aws_api_gateway_method.delete_cake.http_method
  status_code = "204"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "cakes_204" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.cakes.id
  http_method = aws_api_gateway_method.delete_cake.http_method
  status_code = aws_api_gateway_method_response.cakes_204.status_code
}

### CREATE

resource "aws_api_gateway_method" "create_cake" {
  rest_api_id   = aws_api_gateway_rest_api.hornero.id
  resource_id   = aws_api_gateway_resource.cakes.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.hornero_cognito.id
}

resource "aws_api_gateway_integration" "create_cake" {
  rest_api_id             = aws_api_gateway_rest_api.hornero.id
  resource_id             = aws_api_gateway_resource.cakes.id
  http_method             = aws_api_gateway_method.create_cake.http_method
  request_parameters      = {}
  request_templates       = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS" # NOTE: we could try with AWS_PROXY too
  uri                     = module.lambdas.created_lambdas["create_cake"].lambda_function_invoke_arn
}

resource "aws_lambda_permission" "create_cake" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambdas.created_lambdas["create_cake"].lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hornero.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "cakes_201" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.cakes.id
  http_method = aws_api_gateway_method.create_cake.http_method
  status_code = "201"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "cakes_201" {
  rest_api_id = aws_api_gateway_rest_api.hornero.id
  resource_id = aws_api_gateway_resource.cakes.id
  http_method = aws_api_gateway_method.create_cake.http_method
  status_code = aws_api_gateway_method_response.cakes_201.status_code
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
  request_templates       = {}
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS" # NOTE: we could try with AWS_PROXY too
  uri                     = module.lambdas.created_lambdas["create_like"].lambda_function_invoke_arn
}

resource "aws_lambda_permission" "create_like" {
  statement_id  = "AllowHorneroAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambdas.created_lambdas["create_like"].lambda_function_name
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