variable "lambda_runtime" {
    description = "Runtime environment for the Lambda function"
    type        = string
    default     = "python3.12"
}

variable "lambda_name" {
    description = "Name of the first Lambda function to check for palindrome"
    type        = string
}

variable "lambda_exec_role_arn" {
  description = "ARN of the IAM execution role to attach to the Lambda function"
  type        = string
}

variable "lambdafunction_code" {
    description = "Python code for the first Lambda function to check for palindrome"
    type        = string
}