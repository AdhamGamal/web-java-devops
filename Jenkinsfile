pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = credentials('DockerHub') // Jenkins credentials ID
        IMAGE_NAME = "adhamgamal22/simple-web-page" // Docker image name
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "https://github.com/AdhamGamal/web-java-devops.git"
            }
        }
        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Extract Version') {
            steps {
                script {
                    // Extract the app version from pom.xml
                    env.APP_VERSION = sh(
                        script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout",
                        returnStdout: true
                    ).trim()
                    echo "Application Version: ${env.APP_VERSION}"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${env.IMAGE_NAME}:${env.APP_VERSION} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${env.DOCKER_CREDENTIALS}") {
                        sh "docker push ${env.IMAGE_NAME}:${env.APP_VERSION}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Image Version: ${env.APP_VERSION}"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
