resource "aws_api_gateway_rest_api" "apiGateway" {
  name        = "test-api-gateway"
  description = var.apigw_description
}

resource "aws_api_gateway_resource" "apigw-resource" {
    rest_api_id = aws_api_gateway_rest_api.apiGateway.id
    parent_id   = aws_api_gateway_rest_api.apiGateway.root_resource_id
    path_part   = var.apigw_path_part
}
// post method
resource "aws_api_gateway_method" "method_post" {
    rest_api_id   = aws_api_gateway_rest_api.apiGateway.id
    resource_id   = aws_api_gateway_resource.apigw-resource.id
    http_method   = var.apigw_method_post
    authorization = var.apigw_authorization
   # api_key_required = true
    
  #   request_parameters = {
  #   "method.request.path.proxy" = true
  # }

    # request_models       = {
    #    "application/json" = aws_api_gateway_model.my_model.name
    #     }
 
}


resource "aws_api_gateway_method_settings" "method_settings" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  stage_name  = aws_api_gateway_stage.example.stage_name
  method_path = "*/*"
  settings {
    #logging_level = "INFO"
    metrics_enabled = true
  }
}


resource "aws_api_gateway_integration" "integration_post" {
  rest_api_id             = aws_api_gateway_rest_api.apiGateway.id
  resource_id             = aws_api_gateway_resource.apigw-resource.id
  http_method             = aws_api_gateway_method.method_post.http_method
  type                    =  var.integration_type
  integration_http_method = var.apigw_method_post
  uri                     = aws_lambda_function.lambda_post.invoke_arn
  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}

// get method
resource "aws_api_gateway_method" "method_get" {
    rest_api_id   = aws_api_gateway_rest_api.apiGateway.id
    resource_id   = aws_api_gateway_resource.apigw-resource.id
    http_method   = "GET"
    authorization = var.apigw_authorization
   # api_key_required = true
    
  #   request_parameters = {
  #   "method.request.path.proxy" = true
  # }

    # request_models       = {
    #    "application/json" = aws_api_gateway_model.my_model.name
    #     }
 
}

resource "aws_api_gateway_integration" "integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.apiGateway.id
  resource_id             = aws_api_gateway_resource.apigw-resource.id
  http_method             = aws_api_gateway_method.method_get.http_method
  type                    =  var.integration_type
  integration_http_method = var.apigw_method_post
  uri                     = aws_lambda_function.lambda_get.invoke_arn

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}

// delete method
resource "aws_api_gateway_method" "method_delete" {
    rest_api_id   = aws_api_gateway_rest_api.apiGateway.id
    resource_id   = aws_api_gateway_resource.apigw-resource.id
    http_method   = "DELETE"
    authorization = var.apigw_authorization
   # api_key_required = true
    
  #   request_parameters = {
  #   "method.request.path.proxy" = true
  # }

    # request_models       = {
    #    "application/json" = aws_api_gateway_model.my_model.name
    #     }
 
}

resource "aws_api_gateway_integration" "integration_delete" {
  rest_api_id             = aws_api_gateway_rest_api.apiGateway.id
  resource_id             = aws_api_gateway_resource.apigw-resource.id
  http_method             = aws_api_gateway_method.method_delete.http_method
  type                    =  var.integration_type
  integration_http_method = var.apigw_method_post
  uri                     = aws_lambda_function.lambda_delete.invoke_arn

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}
# resource "aws_api_gateway_model" "my_model" {
#   rest_api_id  = aws_api_gateway_rest_api.apiGateway.id
#   name         =var.apigw_model_name
#   description  = var.model_descr
#   content_type = var.model_content_type

#   schema = <<EOF
#   {
#   "$schema" : "http://json-schema.org/draft-04/schema#",
#   "title" : "validateTheBody",
#   "type" : "object",
#   "properties" : {
#     "message" : { "type" : "string" }
#   },
#   "required" :["message"]
#   }
#   EOF
#   }

# resource "aws_api_gateway_usage_plan" "myusageplan" {
#   name = "${var.app_prefix}-usage_plan"

#   api_stages {
#     api_id = aws_api_gateway_rest_api.apiGateway.id
#     stage  = aws_api_gateway_deployment.api.stage_name
#   }
# }

# resource "aws_api_gateway_api_key" "mykey" {
#   name = "${var.app_prefix}-key"
# }

# resource "aws_api_gateway_usage_plan_key" "main" {
#   key_id        = aws_api_gateway_api_key.mykey.id
#   key_type      = var.apigw_key_type
#   usage_plan_id = aws_api_gateway_usage_plan.myusageplan.id
#}

# Mapping lambda Response
# resource "aws_api_gateway_method_response" "http200" {
#   rest_api_id = aws_api_gateway_rest_api.apiGateway.id
#   resource_id = aws_api_gateway_resource.apigw-resource.id
#   http_method = aws_api_gateway_method.method_get.http_method
#   status_code = 200
# }

# resource "aws_api_gateway_integration_response" "http200" {
#   rest_api_id       = aws_api_gateway_rest_api.apiGateway.id
#   resource_id       = aws_api_gateway_resource.apigw-resource.id
#   http_method       = aws_api_gateway_method.method_get.http_method
#   status_code       = aws_api_gateway_method_response.http200.status_code
#   selection_pattern = var.selection_pattern                                       

#   depends_on = [
#     aws_api_gateway_integration.integration_post,
#     ]
# }

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  #stage_name  = var.env

  depends_on = [
    aws_api_gateway_integration.integration_post,aws_api_gateway_integration.integration_delete,
  ]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.apiGateway.id
  stage_name    = "example"
}


