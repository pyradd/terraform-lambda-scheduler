variable "project_name" {
  type        = string
  description = "name of the project"
  default = "terraform-iac-tutorial"
}

variable "prefix" {
  type        = string
  description = "name of the resource prefix"
  default = "lambda-scheduler"
}

variable "environment" {
  type        = string
  description = "name of the enviroment i.e. dev or prod"
  default = "dev"
}
