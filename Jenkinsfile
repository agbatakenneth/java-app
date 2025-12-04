pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    stages {
        stage(''checkout code) {
            steps {
                checkout scm
            }
        }
        stage('RunSonnarCloudAnalysis') {
            steps {
                withCresdentials([string(credentialsId: 'sonar-token', variable: 'SONAR-TOKEN')]) {
                    sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR-TOKEN -Dsonar.organization=agbaken-projects -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=agbaken-projects_java-app'
                }
            }
        }
        stage('Build java Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t kubeagbaken/my-java-app:v1 .'
            }
        }
    
    stage('Push Docker Image') {
        steps {
            withCredentials([usernamePassword(
                credentialsId: 'DOCKER_LOGIN',
                usernameVariable: 'DOCKER_LOGIN',
                passwordVariable: 'PASSWORD'
                )]) {
                    ssh '''
                        echo $PASSWORD | docker login -u $DOCKER_LOGIN --password-stdin
                        docker push kubeagbaken/my-java-app:v1
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build and Docker image-push successful'
        }
        failure {
            echo '❌ Build failed. Check the logs for details'
        }
    }

}
