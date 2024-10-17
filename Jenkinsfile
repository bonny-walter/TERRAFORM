pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-2' // Set your default AWS region
    }
    stages {

        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'git@github.com:bonny-walter/TERRAFORM.git'
            }
        }
        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        cd EKS
                        terraform init
                    '''
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        cd EKS
                        terraform plan -out=tfplan
                    '''
                }
            }
        }
        
        stage('Approval') {
            steps {
                input message: 'Approve deployment to EKS?', ok: 'Deploy'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        cd EKS
                        terraform apply "tfplan"
                    '''
                }
            }
        }
    }
}
