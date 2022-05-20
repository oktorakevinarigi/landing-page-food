pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Environment') {
            steps {
                sh 'git --version'
                echo "Branch: ${env.BRANCH_NAME}"
                sh 'ls'
            }
        }
        stage('Build Docker'){
            steps {
                sh 'sudo docker build -t test:1 .'
            }
        }
        stage('Docker run'){
            steps {
                sh 'sudo docker run -p 3000:80 -d test:1'
            }
        }
    }
}