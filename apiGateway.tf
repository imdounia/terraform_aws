resource "aws_apigatewayv2_api" "gateway" {
  name          = "jobService"
  protocol_type = "HTTP"
}

//integration
resource "aws_apigatewayv2_integration" "intAddJob" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  integration_method = "POST"
  integration_uri =aws_lambda_function.add_job.invoke_arn
}

resource "aws_apigatewayv2_integration" "intWorker" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  integration_method = "POST"
  integration_uri =aws_lambda_function.lambdaWorker.invoke_arn
}

//route
resource "aws_apigatewayv2_route" "routeAddJob" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /addJob"
  target = "integrations/${aws_apigatewayv2_integration.intAddJob.id}"
}

resource "aws_apigatewayv2_route" "routeLambdaWorker" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /worker"
  target = "integrations/${aws_apigatewayv2_integration.intWorker.id}"
}

//permission
resource "aws_lambda_permission" "allow_lambda_invocation_addJob" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.add_job.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
  statement_id  = "AllowExecutionFromAPIGateway"
}

resource "aws_lambda_permission" "allow_lambda_invocation_worker" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambdaWorker.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
  statement_id  = "AllowExecutionFromAPIGateway"
}

resource "aws_lambda_event_source_mapping" "dynamodb_stream_mapping" {
  event_source_arn  = aws_dynamodb_table.job_table.stream_arn
  function_name     = aws_lambda_function.lambdaWorker.arn
  starting_position = "LATEST"
  batch_size        = 10
  maximum_batching_window_in_seconds = 60
}

resource "aws_lambda_permission" "dynamodb_stream_permission" {
  statement_id  = "AllowDynamoDBStreamAccess"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdaWorker.arn
  principal     = "dynamodb.amazonaws.com"
  source_arn    = aws_dynamodb_table.job_table.stream_arn
}



resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "prod"
  auto_deploy = true
}


output "api_endpoint" {
    value = aws_apigatewayv2_api.gateway.api_endpoint
}
output "stage_url" {
    value = aws_apigatewayv2_stage.prod.invoke_url
}
