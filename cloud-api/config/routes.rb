Jets.application.routes.draw do
  post    "recipes/:id/like", to: "recipes#like",   authorizer: "main#my_cognito"
  delete  "recipes/:id/like", to: "recipes#unlike", authorizer: "main#my_cognito"

  resources :recipes, only: [:index, :show, :delete, :create]

  root "jets/public#show"

  # The jets/public#show controller can serve static utf8 content out of the public folder.
  # Note, as part of the deploy process Jets uploads files in the public folder to s3
  # and serves them out of s3 directly. S3 is well suited to serve static assets.
  # More info here: https://rubyonjets.com/docs/extras/assets-serving/
  any "*catchall", to: "jets/public#show"
end
