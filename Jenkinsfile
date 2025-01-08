pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('DockerHub')
        IMAGE_NAME = "adhamgamal22/simple-web-page"
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
                    // Extract the app version from pom.xml and sanitize it
                    env.APP_VERSION = sh(
                        script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout | sed -r 's/\\x1B\\[[0-9;]*[a-zA-Z]//g'",
                        returnStdout: true
                    ).trim()

                    // Validate the version format
                    if (!env.APP_VERSION.matches("[a-zA-Z0-9._-]+")) {
                        error "Invalid version format: ${env.APP_VERSION}"
                    }

                    echo "Application Version (sanitized): ${env.APP_VERSION}"
                }
            }
        }
        stage('Step 4: Build Docker Image') {
            steps {
                script {
                    def version = "${env.IMAGE_NAME}:${env.APP_VERSION}"
                    sh "docker build -t ${version} ."
                    echo "Docker Image Built: ${version}"
                }
            }
        }
        stage('Step 5: Login to DockerHub') {
            steps {
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                echo 'Login Completed'
            }
        }
        stage('Step 6: Push Image to Docker Hub') {
            steps {
                script {
                    def version = "${env.IMAGE_NAME}:${env.APP_VERSION}"
                    sh "docker push ${version}"
                    echo 'Push Image Completed'
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker containers, images, and cloned project files
            echo 'Cleaning up cloned project files...'
            sh 'rm -rf *'                    // Remove cloned project files (Ensure this is safe in your context)
            sh 'docker logout'               // Logout from Docker
            echo 'Cleanup completed'
        }
        success {
            echo "Pipeline completed successfully! Image Version: ${env.APP_VERSION}"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}