variable "resource_prefix" {
  type        = string
  description = "name of the resource prefix"
  default = "lambda-scheduler"
}
variable "lambda_arn" {
  type        = string
  description = "The arn of the lambda function"
}
