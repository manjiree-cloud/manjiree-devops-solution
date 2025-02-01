# private subnet

resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
}

resource "aws_security_group" "lambda_sg"{
    vpc_id                  = data.aws_vpc.vpc.id
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "devops_lambda_function"
  role          = data.aws_iam_role.lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  vpc_config {
    subnet_ids = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  filename = "lanbda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}
