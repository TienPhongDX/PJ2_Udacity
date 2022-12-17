provider "aws" {
  region = var.aws_region
  profile = var.profile
}
resource "aws_cloudwatch_log_group" "logGroup" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 7
}
resource "aws_iam_policy" "iamPoliciesLog" {
  name        = "iamPoliciesLog"
  path        = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "rolelogs" {
  role       = aws_iam_role.roleLambda.name
  policy_arn = aws_iam_policy.iamPoliciesLog.arn
}
resource "aws_iam_role" "roleLambda" {
  name = "roleLambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
data "archive_file" "lambdaZip" {
  type        = "zip"
  source_file = "${path.module}/greet_lambda.py"
  output_path = "${path.module}/lambda.zip"
}
resource "aws_lambda_function" "lambda_greeting" {
  role             = aws_iam_role.roleLambda.arn
  filename         = "lambda.zip"
  source_code_hash = data.archive_file.lambdaZip.output_base64sha256
  function_name    = var.lambda_function_name
  handler          = "${var.lambda_function_name}.lambda_handler"
  runtime          = "python3.8"
  environment {
    variables = {
      greeting = "Hi Udacity"
    }
  }
  depends_on = [aws_cloudwatch_log_group.logGroup, aws_iam_role_policy_attachment.rolelogs]
}