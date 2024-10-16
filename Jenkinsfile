pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/bonny-walter/TERRAFORM.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'cd EKS && terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'cd EKS && terraform plan -out=tfplan'
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
                sh 'cd production && terraform apply "tfplan"'
            }
        }
    }
}

