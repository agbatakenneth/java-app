pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage ('RunSonarCloudAnalysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR-TOKEN', variable: 'SONAR-TOKEN')]) {
                    sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR-TOKEN -Dsonar.organization=agbaken-projects -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=agbaken-projects_java-app'
                }
            }
        }

        stage('Build Java Application') {
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
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]) {
                    sh '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
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
            echo '❌ Build failed. Check the logs for details.'
        }
    }

}


