
resource "aws_iam_role" "sfn_exec_role" {
  name = var.sfn_exec_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "states.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "sfn_lambda_invoke_policy" {
  name = var.sfn_policy_name
  role = aws_iam_role.sfn_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "lambda:InvokeFunction"
      Resource = [
        var.check_for_palindrome_arn,
        var.boolean_lambda_handler_arn
      ]
    }]
  })
}

resource "aws_sfn_state_machine" "state_machine" {
  name     = var.state_machine_name
  role_arn = aws_iam_role.sfn_exec_role.arn
  type     = "STANDARD"

  definition = jsonencode({
    Comment       = "Palindrome Checker State Machine"
    StartAt       = var.state_invoke_palindrome
    QueryLanguage = "JSONata"

    States = {
      (var.state_invoke_palindrome) = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"  # hardcoded - matches Lambda invoke API
        Output   = "{% $states.result.Payload %}"    # hardcoded - standard Lambda response unwrap
        Assign = {
          originalString = "{% $states.input.string %}"
          reverseString  = ""
        }
        Arguments = {
          FunctionName = var.check_for_palindrome_arn
          Payload      = "{% $states.input %}"       # hardcoded - passes full input to Lambda
        }
        Catch = [{
          ErrorEquals = var.catch_error_equals
          Next        = var.state_handle_input_error
        }]
        Retry = [{
          ErrorEquals     = var.retry_error_equals
          IntervalSeconds = var.retry_interval_seconds
          MaxAttempts     = var.retry_max_attempts
          BackoffRate     = var.retry_backoff_rate
          JitterStrategy  = var.retry_jitter_strategy
        }]
        Next = var.state_choice
      }

      (var.state_handle_input_error) = {
        Type = "Pass"
        Output = {
          statusCode = var.error_status_code
          error      = var.error_type
          message    = var.error_message
        }
        End = true
      }

      (var.state_choice) = {
        Type = "Choice"
        Choices = [
          {
            # hardcoded - JSONata condition must reference the actual payload field
            Condition = "{% $states.input.is_palindrome = true %}"
            Next      = var.state_true_invoke
          },
          {
            Condition = "{% $states.input.is_palindrome = false %}"
            Next      = var.state_false_invoke
          }
        ]
      }

      (var.state_true_invoke) = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"  # hardcoded - matches Lambda invoke API
        Output   = "{% $states.result.Payload %}"    # hardcoded - standard Lambda response unwrap
        Arguments = {
          FunctionName = var.boolean_lambda_handler_arn
          Payload      = "{% $states.input %}"
        }
        Assign = {
          reverseString = "{% $originalString %}"
        }
        Retry = [{
          ErrorEquals     = var.retry_error_equals
          IntervalSeconds = var.retry_interval_seconds
          MaxAttempts     = var.retry_max_attempts
          BackoffRate     = var.retry_backoff_rate
          JitterStrategy  = var.retry_jitter_strategy
        }]
        Next = var.state_print_result
      }

      (var.state_false_invoke) = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"  # hardcoded - matches Lambda invoke API
        Output   = "{% $states.result.Payload %}"    # hardcoded - standard Lambda response unwrap
        Arguments = {
          FunctionName = var.boolean_lambda_handler_arn
          Payload      = "{% $states.input %}"
        }
        Assign = {
          reverseString = "{% $join($reverse($split($originalString, '')), '') %}"
        }
        Retry = [{
          ErrorEquals     = var.retry_error_equals
          IntervalSeconds = var.retry_interval_seconds
          MaxAttempts     = var.retry_max_attempts
          BackoffRate     = var.retry_backoff_rate
          JitterStrategy  = var.retry_jitter_strategy
        }]
        Next = var.state_print_result
      }

      (var.state_print_result) = {
        Type = "Pass"
        Output = {
          message        = "{% $states.input.body.message %}"
          originalString = "{% $originalString %}"
          reverseString  = "{% $reverseString %}"
        }
        End = true
      }
    }
  })
}

