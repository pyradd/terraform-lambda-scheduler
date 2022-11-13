output "eventbridge_rule_arn" {
    value = resource.aws_cloudwatch_event_rule.trigger_lambda.arn
    description = "Eventbridge rule arn"
}