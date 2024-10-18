pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-2' // Set your default AWS region
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')

    }
    stages {

        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                
                    
                        
                    sh 'git clone https://github.com/bonny-walter/TERRAFORM.git'
                    
                
            }
        }

        stage('Terraform init') {
            steps {

                sh ' cd TERRAFORM/EKS && terraform init'
            }
        }
        stage('Plan') { 
            steps {
                sh '''
                    cd TERRAFORM/EKS
                    terraform plan -out tfplan'
                    sterraform show -no-color tfplan > tfplan.txt'
                   ''' 
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
