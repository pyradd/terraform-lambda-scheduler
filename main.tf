module "lambda-function" {
  # lambda funtion module
  source          = "./lambda-function"
  resource_prefix = var.prefix
  rule_arn        = module.lambda-scheduler.eventbridge_rule_arn
}

module "lambda-scheduler" {
  source          = "./lambda-scheduler"
  resource_prefix = var.prefix
  lambda_arn      = module.lambda-function.lambda_arn
}
