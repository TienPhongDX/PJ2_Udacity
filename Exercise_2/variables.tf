# TODO: Define the variable for aws_region
variable "aws_region" {
  type        = string
  default     = "us-east-1"
}
variable "profile" {
  type        = string
  default = "default"
}
variable "lambda_function_name" {
  type        = string
  default     = "greet_lambda"
}
