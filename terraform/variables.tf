variable "lambda_role_name" {
    description = "Name of the IAM role for Lambda execution"
    type        = string
    default     = "LambdaExecutionRole"
}

variable "lambda_attaching_policy" {
    description = "Name of the policy to attach to the Lambda execution role"
    type        = string
    default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "check_for_palindrome_name" {
    description = "Name of the check for palindrome Lambda function"
    type        = string
}

variable "boolean_lambda_handler_name" {
    description = "Name of the boolean Lambda handler function"
    type        = string
}

variable "check_for_palindrome_code" {
    description = "Python code for the check for palindrome Lambda function"
    type        = string
}

variable "boolean_lambda_handler_code" {
    description = "Python code for the boolean Lambda handler"
    type        = string

}

variable "lambda_runtime" {
    description = "Runtime environment for the Lambda functions"
    type        = string
}