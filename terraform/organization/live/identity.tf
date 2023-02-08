resource "aws_cognito_user_pool" "user_pool" {
  name = "user_pool"
}

resource "aws_cognito_user_pool_client" "webapp" {
  name = "webapp"

  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = true

  access_token_validity = 60
  allowed_oauth_flows   = [
    "code"
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

  callback_urls = [
    "https://${module.static_site.cdn_domain_name}/sign_in_callback"
  ]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
  }
}
