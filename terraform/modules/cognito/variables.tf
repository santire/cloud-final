variable "backend_callback_url" {
  description = "Callback to redirect users after sign in/up"
  type        = string
}

variable "post_confirmation_lambda_name" {
  type = string
  description = "Name of the lambda to run after a user has been confirmed"
}