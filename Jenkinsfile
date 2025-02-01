pipeline {
    agent any
    environment {
        LAMBDA_FUNCTION_NAME = "devops_candidate_lambda"
    }
    stages {
        stage('TF Init') {
            steps {
                echo 'Executing Terraform Init...'
                script {
                    try {
                        sh "terraform init"                        
                    } catch (Exception e) {
                        echo "An error occurred: ${e.getMessage()}"
                    }                    
                }
            }
        }
        stage('TF Validate') {
            steps {
                echo 'Validating Terraform Code...'
                script {
                    try {
                        sh 'terraform validate'                        
                    } catch (Exception e) {
                        echo "An error occurred: ${e.getMessage()}"
                    }                    
                }
            }
        }
        stage('TF Plan') {
            steps {
                echo 'Executing Terraform Plan...'
                script {
                    try {
                        sh 'terraform plan'                        
                    } catch (Exception e) {
                        echo "An error occurred: ${e.getMessage()}"
                    } 
                }
            }
        }
        stage('TF Apply') {
            steps {
                echo 'Executing Terraform Apply'
                script {
                    try {
                        sh 'terraform apply -auto-approve'                       
                    } catch (Exception e) {
                        echo "An error occurred: ${e.getMessage()}"
                    }
                }
            }
        }
        stage('Invoke Lambda') {
            steps {
                echo "Invoking your AWS Lambda"
                script {
                    try {
                        echo "Invoking Lambda..."
                        def result = sh(script: """
                        aws lambda invoke \
                            --function-name ${LAMBDA_FUNCTION_NAME} \
                            --payload '{}' \
                            --log-type Tail \
                            response.json
                        """, returnStdout: true).trim()
                        
                        def statusCode = jq -r '.StatusCode' output.json | base64 --decode
                        if (statusCode == 200) {
                            echo "Lambda function Invoked Successfully."
                        } else {
                            echo "Lambda function Invokation Failed."
                        }
                        
                    } catch (Exception e) {
                        echo "An error occurred: ${e.getMessage()}"
                    }                    
                }
            }
        }
    }
}
