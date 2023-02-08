resource "aws_cognito_user_pool" "user_pool" {
  name = "user_pool"

  auto_verified_attributes = ["email"]

  schema {
    name      = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false  # false for "sub"
    required                 = true # true for "sub"

    string_attribute_constraints {   # if it is a string
      min_length = 1                 # 10 for "birthdate"
      max_length = 2048              # 10 for "birthdate"
    }
  }

  schema {
    name      = "profile"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false  # false for "sub"
    required                 = true # true for "sub"

    string_attribute_constraints {   # if it is a string
      min_length = 1                 # 10 for "birthdate"
      max_length = 2048              # 10 for "birthdate"
    }
  }

  lambda_config {
    post_confirmation = "arn:aws:lambda:us-east-1:660472391051:function:lambdas-dev-sign_up"
  }

}


resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.post_confirmation_lambda_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.user_pool.arn
}


resource "aws_cognito_user_pool_client" "webapp" {
  name = "webapp"

  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = true

  access_token_validity = 60
  allowed_oauth_flows   = [
    "implicit"
  ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = [
    "aws.cognito.signin.user.admin",
    "email",
    "openid",
    "phone",
    "profile",
  ]

  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]

  id_token_validity = 60
  read_attributes   = [
    "address",
    "birthdate",
    "email",
    "email_verified",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "phone_number_verified",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo"
  ]

  supported_identity_providers = [
    "COGNITO"
  ]

  write_attributes = [
    "address",
    "birthdate",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo"
  ]

  callback_urls = [var.backend_callback_url]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
  }
}


resource "aws_cognito_user_pool_domain" "main" {
  domain       = "final-cloud-2022c2"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
