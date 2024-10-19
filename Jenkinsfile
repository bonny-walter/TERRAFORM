pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-2' // Set your default AWS region
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID ')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')

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

        
    }
}
