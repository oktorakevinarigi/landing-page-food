    node {
  try {
    stage('Checkout') {
      checkout scm
    }
    stage('Environment') {
      sh 'git --version'
      echo "Branch: ${env.BRANCH_NAME}"
      sh 'docker -v'
      sh 'printenv'
    }
    stage('Build Docker'){
      sh 'docker build -t test:1 .'
    }
    stage('Docker run'){
      sh 'docker run -p 3000:80 -d test:1'
    }
  }
  catch (err) {
    throw err
  }
}