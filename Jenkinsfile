pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent'
            defaultContainer 'jnlp'
        }
    }
    stages {
        stage('Clone') {
            steps {
                sh 'git clone https://github.com/lhj1230/spring-petclinic.git'
            }
        }
        stage('Deploy to K8s') {
            steps {
                sh '''
                kubectl apply -f spring-petclinic/k8s/db.yml
                kubectl apply -f spring-petclinic/k8s/petclinic.yml
                '''
            }
        }
    }
}
