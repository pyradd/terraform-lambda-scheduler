output "lambda_arn" {
    value = resource.aws_lambda_function.test_lambda.arn
    description = "Lambda function ARN"
}