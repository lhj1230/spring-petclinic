pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent'
            defaultContainer 'jnlp'
        }
    }
    stages {
        stage('Check') {
            steps {
                sh 'echo Hello from Jenkins agent pod!'
            }
        }
    }
}
       
