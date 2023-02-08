module "cron_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 3.4.2"

  name       = "dlq-select-winner"
  fifo_queue = false
}

module "cron" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus     = false
  create_targets = true
  create_role    = false

  rules = {
    crons = {
      description         = "Trigger at Friday's night"
      schedule_expression = "cron(0 22 ? * 5 *)"
    }
  }

  targets = {
    crons = [
      {
        name  = "trigger-select-winner"
        arn   = module.lambdas.created_lambdas["select_winner"].lambda_function_arn
        input = jsonencode({"job": "cron-by-rate"})

        dead_letter_arn = module.cron_queue.sqs_queue_arn
      }
    ]
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambdas.created_lambdas["select_winner"].lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = module.cron.eventbridge_rule_arns["crons"]
}
