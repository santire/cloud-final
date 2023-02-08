class MainAuthorizer < ApplicationAuthorizer
  authorizer(
    name: "MyCognito", # <= name is used as the "function" name
    identity_source: "Authorization", # maps to method.request.header.Authorization
    type: :cognito_user_pools,
    provider_arns: [
      "arn:aws:cognito-idp:us-east-1:985972503236:userpool/us-east-1_ikmcN0E1y",
    ],
  )
  # no lambda function
end
