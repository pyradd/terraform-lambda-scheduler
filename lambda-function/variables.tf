variable "resource_prefix" {
  type        = string
  description = "name of the resource prefix"
  default     = "eixww"
}
variable "rule_arn" {
  type        = string
  description = "Eventbridge rule arn"
}