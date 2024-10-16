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
                        string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'aws-access-key-id'),
                        string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'aws-secret-access-key')
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
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'aws-access-key-id'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'aws-secret-access-key')
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
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'aws-access-key-id'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'aws-secret-access-key')
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
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'aws-access-key-id'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'aws-secret-access-key')
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

