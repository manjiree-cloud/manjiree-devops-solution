pipeline {
    agent any
    environment {
        TF_BACKEND_BUCKET = '467.devops.candidate.exam'
        TF_REGION = "ap-south-1"
        BRANCH_NAME = "main"
    }
    stages {
        stage('TF Init') {
            steps {
                echo 'Executing Terraform Init'
                script {
                    // Initialize Terraform with the backend configuration
                    sh "terraform init -backend-config='bucket=${TF_BACKEND_BUCKET}' -backend-config='key=${env.BRANCH_NAME}.tfstate' -backend-config='region=${AWS_REGION}'"
                }
            }
        }
        stage('TF Validate') {
            steps {
                echo 'Validating Terraform Code'
                script {
                    sh 'terraform validate'
                }
            }
        }
        stage('TF Plan') {
            steps {
                echo 'Executing Terraform Plan'
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('TF Apply') {
            steps {
                echo 'Executing Terraform Apply'
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Invoke Lambda') {
            steps {
                echo "Invoking your AWS Lambda"
                script {
                     sh '''aws lambda invoke \
                    --function-name devops_lambda_function \
                    response.json'''
                }
            }
        }
    }
}
