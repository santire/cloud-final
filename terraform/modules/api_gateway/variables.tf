variable "user_pool_arn" {
  description = "User pool for Cognito integration"
  type        = string
}

variable "lambdas" {
  description = "Lambdas information"
  type        = map(map(string))
}