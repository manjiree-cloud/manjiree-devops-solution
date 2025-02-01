provider "aws" {
    region = "ap-south-1"
}

data "aws_vpc" "vpc" {
    id = "vpc-06b326e20d7db55f9"
}

data "aws_nat_gateway" "nat"{
    id = "nat-0a34a8efd5e420945"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = data.aws_vpc.vpc.id
    cidr_blocks = "10.0.4.0/24" 
    availability_zone = "ap-south-1a" 
    map_public_ip_on_launch = false 

    tags = {
        Name = "Private Subnet"
    }
}
# Route Table Resource (for private subnet)

resource "aws_route_table" "private_route_table" {
    vpc_id= data.aws_vpc.vpc.id

    route {
        cidr_blocks = "10.0.0.0/16" 
        nat_gateway_id = data.aws_nat_gateway.nat.id 
          }
          
    tags = {
        Name "Private Route Table"
          }
}

#Associate Route Table with Private Subnet

resource "aws_route_table_association" "private_route_association" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private_route_table.id
}

#Lambda IAM Role (you may reference this IAM Role in your Lambda function)

resource "aws_iam_role" "lambda_role" {
    name = "DevOps-Candidate-Lambda-Role"
    assume role policy = įsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts: AssumeRole"
            Effect "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }
    ]
    })
}

# Lambda IAM Policy (attach this policy to the Lambda Role)

resource "aws_iam_role_policy" "lambda_policy" {
    name = "LambdaPolicy"
    role = aws_iam_role.lambda_role.id
    policy = jsonencode({
        Version "2012-10-17"
        Statement = [
            {
                Action = [
                    "lambda InvokeFunction",
                    "logs:*",
                    "s3:*"  
                ] 
                Effect "Allow"
                Resource = "*"
            }
        ]
    })
}

resource "aws_lambda_function" "lambda" {
  function_name = "devops_candidate_lambda"
  role          = data.aws_iam_role.lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
        "KEY" = "value"
    }
  }
}


resource "aws_security_group" "lambda_sg"{
    vpc_id  = data.aws_vpc.vpc.id

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    ingress {
       cidr_blocks = ["10.0.0.0/16"]
        from_port = 0
        to_port = 65535
        protocol = "tcp" 
    }

    tags = {
        Name= "Lambda Security Group"
    }
}




