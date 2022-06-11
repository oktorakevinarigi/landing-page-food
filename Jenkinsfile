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
                sh 'docker compose up -d'
            }
        }
    }
}