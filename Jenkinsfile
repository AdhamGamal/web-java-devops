pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('DockerHub') // Jenkins credentials ID
        IMAGE_NAME = "adhamgamal22/simple-web-page" // Docker image name
    }

    stages {
        stage('Step 1: Clone Repository') {
            steps {
                git branch: 'main', url: "https://github.com/AdhamGamal/web-java-devops.git"
                echo 'Git Clone Completed'
            }
        }
        stage('Step 2: Build WAR') {
            steps {
                sh 'mvn clean package'
                echo 'Project Build Completed'
            }
        }
        stage('Step 3: Extract Version') {
            steps {
                script {
                    // Extract the app version from pom.xml
                    env.APP_VERSION = sh(
                        script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout",
                        returnStdout: true
                    ).trim()
                    
                    // Clean the version to remove unwanted characters
                    env.APP_VERSION = env.APP_VERSION.replaceAll("[^a-zA-Z0-9.-]", "")
                    echo "Application Version: ${env.APP_VERSION}"
                }
            }
        }
        stage('Step 4: Build Docker Image') {
            steps {
                sh "docker build -t ${env.IMAGE_NAME}:${env.APP_VERSION} ."
                echo 'Build Image Completed'
            }
        }
        stage('Step 5: Login to DockerHub') {
            steps{
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                echo 'Login Completed'
            }
        }
        stage('Step 6: Push Image to Docker Hub') {
            steps{
                sh "docker push ${env.IMAGE_NAME}:${env.APP_VERSION}"
                echo 'Push Image Completed'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            echo 'Logout Completed'
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}