resource "aws_subnet" "private_subnet" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr

  tags = {
    Name = "Private Subnet"
  }
}
# Route Table Resource (for private subnet)

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

#Associate Route Table with Private Subnet

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "lambda_sg" {
  vpc_id = data.aws_vpc.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "Lambda Security Group"
  }
}

resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = "requests-layer"
  description         = "Lambda layer containing the requests library"
  filename            = "lambda_layers/requests_layer.zip"
  compatible_runtimes = ["python3.8", "python3.9", "python3.10", "python3.11", "python3.12"]
}


resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  role             = data.aws_iam_role.lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.lambda_runtime
  filename         = "lambda_function.zip"
  layers           = [aws_lambda_layer_version.requests_layer.arn]
  source_code_hash = filebase64sha256("lambda_function.zip")
  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
  environment {
    variables = {
      SUBNET_ID = "10.0.4.0/24"
      NAME      = "Manjiree Pahade"
      EMAIL     = "pahademanjiree@gmail.com"
    }
  }
}




