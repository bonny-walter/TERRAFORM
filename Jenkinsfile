pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-2'  // Set your default AWS region
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/bonny-walter/TERRAFORM.git'
            }
        }

        stage('Test AWS Credentials') {
                steps {
                    withCredentials([
                        string(credentialsId: 'aws-access-key-id', variable: 'aws-access-key-id'),
                        string(credentialsId: 'aws-secret-access-key', variable: 'aws-secret-access-key')
                    ]) {
                        sh '''
                            aws sts get-caller-identity
                        '''
                    }
                }
            }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'aws-access-key-id'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'aws-secret-access-key')
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
                    string(credentialsId: 'aws-access-key-id', variable: 'aws-access-key-id'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'aws-secret-access-key')
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
                // Send a Slack notification that the pipeline is waiting for approval
                slackSend channel: '#deployments', message: 'Waiting for approval to deploy to production. Please review the Terraform plan and approve in Jenkins.'

                // Pause for manual approval in Jenkins
                input message: 'Approve deployment to production?', ok: 'Deploy'
            }
        }
        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'aws-access-key-id'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'aws-secret-access-key')
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

