# -------------------------------------------------------
# General
# -------------------------------------------------------
variable "state_machine_name" {
  description = "Name of the Step Functions state machine"
  type        = string
  default     = "PalindromeCheckerTF"
}

variable "check_for_palindrome_arn" {
  description = "ARN of the CheckForPalindrome Lambda function"
  type        = string
}

variable "boolean_lambda_handler_arn" {
  description = "ARN of the BooleanLambdaHandler Lambda function"
  type        = string
}

variable "sfn_exec_role_name" {
  description = "Name of the IAM execution role for Step Functions"
  type        = string
  default     = "sfn_exec_role"
}

variable "sfn_policy_name" {
  description = "Name of the IAM policy for Step Functions Lambda invocation"
  type        = string
  default     = "sfn_invoke_policy"
}

# -------------------------------------------------------
# State Names
# -------------------------------------------------------
variable "state_invoke_palindrome" {
  description = "Name of the first Task state that invokes the palindrome checker Lambda"
  type        = string
  default     = "Invoke Palindrome Function"
}

variable "state_handle_input_error" {
  description = "Name of the Pass state that handles invalid input errors"
  type        = string
  default     = "HandleInputError"
}

variable "state_choice" {
  description = "Name of the Choice state that branches on palindrome result"
  type        = string
  default     = "Choice"
}

variable "state_true_invoke" {
  description = "Name of the Task state invoked when input is a palindrome"
  type        = string
  default     = "TrueLambdaInvoke"
}

variable "state_false_invoke" {
  description = "Name of the Task state invoked when input is not a palindrome"
  type        = string
  default     = "FalseLambdaInvoke"
}

variable "state_print_result" {
  description = "Name of the final Pass state that prints the result"
  type        = string
  default     = "PrintResult"
}


# -------------------------------------------------------
# Error Handling
# -------------------------------------------------------
variable "catch_error_equals" {
  description = "List of error types to catch from the palindrome Lambda"
  type        = list(string)
  default     = ["ValueError"]
}

variable "error_status_code" {
  description = "Status code to return on input error"
  type        = number
  default     = 400
}

variable "error_message" {
  description = "Error message to return when input is invalid"
  type        = string
  default     = "Missing or invalid 'string' field in input"
}

variable "error_type" {
  description = "Error type label returned in the HandleInputError state"
  type        = string
  default     = "Invalid input"
}

# -------------------------------------------------------
# Retry Configuration
# -------------------------------------------------------
variable "retry_error_equals" {
  description = "List of Lambda error types to retry on"
  type        = list(string)
  default     = [
    "Lambda.ServiceException",
    "Lambda.AWSLambdaException",
    "Lambda.SdkClientException",
    "Lambda.TooManyRequestsException"
  ]
}

variable "retry_interval_seconds" {
  description = "Initial retry interval in seconds"
  type        = number
  default     = 1
}

variable "retry_max_attempts" {
  description = "Maximum number of retry attempts"
  type        = number
  default     = 3
}

variable "retry_backoff_rate" {
  description = "Backoff rate multiplier between retry attempts"
  type        = number
  default     = 2
}

variable "retry_jitter_strategy" {
  description = "Jitter strategy for retries"
  type        = string
  default     = "FULL"
}
