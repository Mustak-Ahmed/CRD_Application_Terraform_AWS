variable "region" {
  description = "The AWS region to create things in."
  default="us-east-1"
}

variable "env" {
  description = "branch"
  default = "dev"
}

variable "apigw_description" {
  default = "POST records to Lambda"
}
variable "apigw_path_part" {
  default = "{proxy+}"
}
variable "apigw_method_post" {
  default="POST"
}
variable "apigw_method_delete" {
  default="DELETE"
}
variable "apigw_method_get" {
  default="GET"
}
variable "lambda_handler" {
  default = "handler_post.lambda_handler"
}
variable "lambda_timeout" {
    default = 30
  
}
variable "lambda_memory" {
    default = 128
  
}
variable "lambda_name" {
    description = "Name for lambda function"
    default = "lambda"
}
variable "apigw_authorization" {
  default="NONE"
}
variable "integration_type" {
  default="AWS_PROXY"
}
variable "selection_pattern" {
  default = "^2[0-9][0-9]"
}
variable "table_name" {
  description = "Dynamodb table name (space is not allowed)"
  default = "test-table"
}

variable "table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  default = "PAY_PER_REQUEST"
}