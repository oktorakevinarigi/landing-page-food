pipeline {
    agent any
    stages {
        stage('Environment') {
            steps {
                sh 'git --version'
                echo "Branch: ${env.BRANCH_NAME}"
                sh 'ls'
            }
        }
        stage('send notif start'){
            steps {
                sh 'docker compose version'
            }
        }
        stage('send notif start'){
            steps {
                slackSend channel: 'jenkins-notification', message: 'mulai'
            }
        }
        stage('Build Docker'){
            steps {
                sh 'docker compose up -d'
            }
        }
        stage('send notif end'){
            steps {
                slackSend channel: 'jenkins-notification', message: 'selesai'
            }
        }
    }
}