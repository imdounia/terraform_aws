resource "aws_lambda_function" "lambdaWorker" {
  filename         = "${path.module}/lambda_code/lambdaWorker.js.zip"
  function_name    = "lambdaWorker"
  role             = "${aws_iam_role.role.arn}"
  handler          = "lambdaWorker.handler"
  runtime          = "nodejs14.x"
  source_code_hash = "${filebase64sha256("${path.module}/lambda_code/lambdaWorker.js.zip")}"
}