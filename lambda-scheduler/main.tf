## Cloudwatch event rule definition
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule
resource "aws_cloudwatch_event_rule" "trigger_lambda" {
  name                = "${var.resource_prefix}-Trigger-Lambda"
  description         = "Triggers the target lambda function on selected Schedule"
  schedule_expression = "rate(2 minutes)" # can be either "cron(0 03 * * ? *)" or rate(5 minutes)
}
## registering the lambda funtion as the target of cloudwatch event
resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.trigger_lambda.name
  target_id = "TriggerLambda"
  arn       = var.lambda_arn
}

## IAM role for cloudwatch event (eventbridge) execution
resource "aws_iam_role" "iam_for_eventbridge" {
  name = "${var.resource_prefix}-iam_for_eventbridge"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}
