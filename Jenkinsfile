pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent'
            defaultContainer 'jnlp'
        }
    }
    stages {
        stage('Test') {
            steps {
                sh 'echo Hello from Kubernetes agent'
            }
        }
    }
}
