variable "private_subnet_cidr" {
  description = "Private Subnet CIDR Range"
  type        = string
  default     = "10.0.4.0/24"
}

variable "vpc_cidr" {
  description = "Vpc Cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "function_name" {
  description = "Lambda Function Name"
  type        = string
  default     = "devops_candidate_lambda"
}

variable "lambda_runtime" {
  description = "Lambda Runtime"
  type        = string
  default     = "python3.8"
}



