pipeline {
    agent any

    tools {
        maven "M3"
        jdk "JDK21"
    }

    triggers {
        githubPush()
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerCredential')
        REGION = "ap-northeast-2"
        AWS_CREDENTIALS_NAME = "aws-project5"
    }

    stages {
        stage('Git Clone') {
            steps {
                echo 'Git Clone'
                git url: 'https://github.com/lhj1230/spring-petclinic.git',
                    branch: 'main', credentialsId: 'git_classic_token'
            }
            post {
                success {
                    echo 'Git Clone Success'
                }
                failure {
                    echo 'Git Clone Fail'
                }
            }
        }
        // Maven build 작업
        stage('Maven Build') {
            steps {
                echo 'Maven Build'
                sh 'mvn -Dmaven.test.failure.ignore=true clean package' // Test error 무시
            }
            post {
                success {
                    echo 'Build Success'
                }
                failure {
                    echo 'Build Fail'
                }
            }
        }

        // Docker Image 생성
        stage('Docker Image Build') {
            steps {
                echo 'Docker Image Build'
                dir("${env.WORKSPACE}") {
                    sh '''
                        docker build -t spring-petclinic:$BUILD_NUMBER .
                        docker tag spring-petclinic:$BUILD_NUMBER mightyi/spring-petclinic:latest
                    '''
                }
            }
        }

        // Docker Image Push
        stage('Docker Image Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerCredential', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push mightyi/spring-petclinic:latest
                    '''
                }
            }     
        }

        // Remove Docker Image
        stage('Remove Docker Image') {
            steps {
                sh '''
                    docker rmi spring-petclinic:$BUILD_NUMBER
                    docker rmi mightyi/spring-petclinic:latest
                '''
            }
        }

        stage('Upload S3') {
            steps {
                echo "Upload to S3"
                dir("${env.WORKSPACE}") {
                    sh 'zip -r scripts.zip ./scripts appspec.yml'
                    withAWS(region: "${REGION}", credentials: "${AWS_CREDENTIALS_NAME}") {
                        s3Upload(file: "scripts.zip", bucket: "project5-bucket-jks")
                    }
                    sh 'rm -rf ./scripts.zip'
                }
            }
        }

        stage('Codedeploy Workload') {
            steps {
                echo "Codedeploy Workload"
                withAWS(region: "${REGION}", credentials: "${AWS_CREDENTIALS_NAME}") {
                    sh '''
                        aws deploy create-deployment --application-name TEAM5_deploy \
                        --deployment-config-name CodeDeployDefault.OneAtATime \
                        --deployment-group-name TEAM5_deploy_group \
                        --ignore-application-stop-failures \
                        --s3-location bucket=team5-codedeploy-bucket,bundleType=zip,key=scripts.zip
                    '''
                }
                sleep(10) // sleep 10s
            }
        }
    }
}
