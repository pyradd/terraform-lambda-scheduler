data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/hello-world" # directory where your lambda funtion is located. path.module refers to terraform-iac/scheduled-lambda-deployment/lambda-function/ directory
  output_path = "${path.module}/hello-world.zip" # where the zip file should be stored
}

########################################################################################################################################################################
#                     _            _           _       _                             _         _            _        _         __              _   _          
#   _ _ ___ __ _ _  _(_)_ _ ___ __| |  _ _ ___| |___  | |_ ___   _____ _____ __ _  _| |_ ___  | |__ _ _ __ | |__  __| |__ _   / _|_  _ _ _  __| |_(_)___ _ _  
#  | '_/ -_) _` | || | | '_/ -_) _` | | '_/ _ \ / -_) |  _/ _ \ / -_) \ / -_) _| || |  _/ -_) | / _` | '  \| '_ \/ _` / _` | |  _| || | ' \/ _|  _| / _ \ ' \ 
#  |_| \___\__, |\_,_|_|_| \___\__,_| |_| \___/_\___|  \__\___/ \___/_\_\___\__|\_,_|\__\___| |_\__,_|_|_|_|_.__/\__,_\__,_| |_|  \_,_|_||_\__|\__|_\___/_||_|
#             |_|                                                                                                                                                                                      
#########################################################################################################################################################################
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.resource_prefix}-iam_for_lambda"

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

########################################################################################################################################################################
#   ___     _ _                             _            _   _                    _ _         _                _           _             _             _      _    
#  | _ \___| (_)__ _  _   _ _ ___ __ _ _  _(_)_ _ ___ __| | | |_ ___  __ __ ___ _(_) |_ ___  | |___  __ _ ___ (_)_ _    __| |___ _  _ __| |_ __ ____ _| |_ __| |_  
#  |  _/ _ \ | / _| || | | '_/ -_) _` | || | | '_/ -_) _` | |  _/ _ \ \ V  V / '_| |  _/ -_) | / _ \/ _` (_-< | | ' \  / _| / _ \ || / _` \ V  V / _` |  _/ _| ' \ 
#  |_| \___/_|_\__|\_, | |_| \___\__, |\_,_|_|_| \___\__,_|  \__\___/  \_/\_/|_| |_|\__\___| |_\___/\__, /__/ |_|_||_| \__|_\___/\_,_\__,_|\_/\_/\__,_|\__\__|_||_|
#                  |__/             |_|                                                             |___/                                                          
#########################################################################################################################################################################
data "aws_iam_policy_document" "attched_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
resource "aws_iam_policy" "cloudwatch_access" {
  name   = "${var.resource_prefix}-access-policy"
  policy = data.aws_iam_policy_document.attched_policy.json
}
resource "aws_iam_role_policy_attachment" "attach-policy" {
  role       = aws_iam_role.iam_for_lambda.name 
  policy_arn = aws_iam_policy.cloudwatch_access.arn
}

### Allow eventridge/former cloudwatch event to trigger lambda function ###
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = "${var.rule_arn}"
}

### Your lambda funtion ###
resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.

  filename      = "${path.module}/hello-world.zip"
  function_name = "${var.resource_prefix}-lambda-function"
  role          = aws_iam_role.iam_for_lambda.arn ## Attaching the role we created above
  handler       = "main.lambda_handler" # reference to lambda_handler

  layers = ["arn:aws:lambda:eu-central-1:292169987271:layer:AWSLambda-Python38-SciPy1x:29"] # example of how to add layers

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  runtime = "python3.9" # you can specify any valid runtime such as "nodejs16.x"

  environment {
    variables = {
      foo = "bar" # way to define environmental variables inside the lambda funtion
    }
  }
}
