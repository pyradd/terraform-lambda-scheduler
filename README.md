# Scheduled aws-lambda deployment with terraform

A minimal example of deploying a lambda funtion and an eventbridge scheduler with terraform IaC.

## Requirements

`terraform ">= 0.14.9"`

`aws cli`

## Repository Structure

```
Lambda-function: Module directory containing the lambda function and all its required resources
lambda-scheduler: Module directory containing aws eventbridge scheduler and all its required resources
main.tf: Entrypoint to the terraform module
providers.tf:  aws provider configuration
root.tf: Defines terraform provider and terraform version constraint
variables.tf: Defines variables to be used by the root module
locals.tf: Defines local variables to be used by the terraform modules 
```

The individual terraform scripts have been explained via comments within the scripts.

## Usage
1. Initialize

    `terraform init`

2. To plan deployment

    `terraform plan`

3. To deploy resources

    `terraform apply`

4. To destroy resources

    `terraform destroy`