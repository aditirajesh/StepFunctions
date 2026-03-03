resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = var.lambda_attaching_policy
}

module "check_for_palindrome" {
  source               = "./modules/lambda"
  lambda_name          = var.check_for_palindrome_name
  lambda_exec_role_arn = aws_iam_role.lambda_exec_role.arn
  lambda_runtime = var.lambda_runtime
  lambdafunction_code  = var.check_for_palindrome_code
  depends_on           = [aws_iam_role_policy_attachment.lambda_basic_execution]

}

module "boolean_lambda_handler" {
  source               = "./modules/lambda"
  lambda_name          = var.boolean_lambda_handler_name
  lambda_exec_role_arn = aws_iam_role.lambda_exec_role.arn
  lambda_runtime = var.lambda_runtime
  lambdafunction_code  = var.boolean_lambda_handler_code
  depends_on           = [aws_iam_role_policy_attachment.lambda_basic_execution]

}

module "stepfunction" {
  source                     = "./modules/stepfunction"
  check_for_palindrome_arn   = module.check_for_palindrome.lambda_function_arn
  boolean_lambda_handler_arn = module.boolean_lambda_handler.lambda_function_arn
}