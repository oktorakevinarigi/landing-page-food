pipeline {
    agent any
    stages {
        stage('Checkout') {
        checkout scm
        }
        stage('Environment') {
        sh 'git --version'
        echo "Branch: ${env.BRANCH_NAME}"
        sh 'ls'
        }
        stage('Build Docker'){
        sh 'docker build -t test:1 .'
        }
        stage('Docker run'){
        sh 'sudo docker run -p 3000:80 -d test:1'
        }
    }
}