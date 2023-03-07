data "archive_file" "lambda_with_dependencies_delete" {
  source_dir  = "lambda/"
  output_path = "${var.lambda_name}-delete.zip"
  type        = "zip"
}

resource "aws_lambda_function" "lambda_delete" {
  function_name    = "delete-lambda"
  handler          = "handler_delete.lambda_handler"
  role             = aws_iam_role.lambda_role_delete.arn
  runtime          = "python3.7"

  filename         = data.archive_file.lambda_with_dependencies_delete.output_path
  source_code_hash = data.archive_file.lambda_with_dependencies_delete.output_base64sha256

  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory

  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_delete
  ]
}

 # IAM role which dictates what other AWS services the Lambda function may access.
resource "aws_iam_role" "lambda_role_delete" {
   name = "serverless_example_lambdapy_delete"

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
resource "aws_iam_policy" "iam_policy_for_lambda_delete"{

  name        = "iam-policy-lambda_delete"
  path        = "/"
  description = "Adobe-lambda-policy"
  policy      = <<EOF
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
   },
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "ecr:*"
        ],
        "Resource": "*"
    },
      {
        "Effect": "Allow",
        "Action": [
             "apigateway:*"
        ],
        "Resource": "*"
      },
      {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "dynamodb:*"
        ],
        "Resource": "*"
    }
 ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_delete" {
  role       = aws_iam_role.lambda_role_delete.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda_delete.arn
}

resource "aws_lambda_permission" "apigw_delete" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda_delete.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.apiGateway.execution_arn}/*/*"
}
