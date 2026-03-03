

data "archive_file" "lambda_code_zip" {
  type        = "zip"
  output_path = "${path.module}/${var.lambda_name}.zip"

  source {
    content  = var.lambdafunction_code
    filename = "lambda_function.py"
  }
}


resource "aws_lambda_function" "lambda_function" {
  function_name    = var.lambda_name
  role             = var.lambda_exec_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.lambda_runtime
  filename         = data.archive_file.lambda_code_zip.output_path
  source_code_hash = data.archive_file.lambda_code_zip.output_base64sha256
}