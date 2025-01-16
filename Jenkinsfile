pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'adhamgamal22/java-web-app'
        GIT_REPO = 'https://github.com/AdhamGamal/web-java-devops.git'
        BRANCH = 'main'
        DOCKER_HUB_CREDENTIALS = 'dockerhub-credentials'
        SSH_CREDENTIALS = 'ssh-credentials'
        DROPLET_IP = '157.230.96.168'
    }

    stages {
        stage('Step 1: Checkout Code') { 
            steps {
                echo 'Checking out code from GitHub...'
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Step 2: Extract Project Version') { 
            steps {
                script {
                    try {
                        echo 'Extracting project version...'
                        env.PROJECT_VERSION = sh(
                            script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout | sed -r 's/\\x1B\\[[0-9;]*[a-zA-Z]//g'",
                            returnStdout: true
                        ).trim()

                        if (!env.PROJECT_VERSION.matches("[a-zA-Z0-9._-]+")) {
                            error "Invalid version format: ${env.PROJECT_VERSION}"
                        }
                        echo "Application Version: ${env.PROJECT_VERSION}"
                    } catch (Exception e) {
                        error "Failed to extract version: ${e.message}"
                    }
                }
            }
        }

        stage('Step 3: Build WAR') { 
            steps {
                script {
                    try {
                        sh 'mvn clean package'
                        echo 'Project Build Completed'
                    } catch (Exception e) {
                        error "Build failed: ${e.message}"
                    }
                }
            }
        }

        stage('Step 4: Build Docker Image') { 
            steps {
                script {
                    echo 'Building Docker image using existing Dockerfile...'
                    sh "docker build -t ${DOCKER_IMAGE}:${env.PROJECT_VERSION} ."
                }
            }
        }

        stage('Step 5: Push Docker Image to Docker Hub') { 
            steps {
                script {
                    echo 'Pushing Docker image to Docker Hub...'
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
                        docker push ${DOCKER_IMAGE}:${env.PROJECT_VERSION}
                        """
                    }
                }
            }
        }

        stage('Step 6: SSH to Droplet and Deploy') { 
            steps {
                script {
                    def image_name = "${DOCKER_IMAGE}:${env.PROJECT_VERSION}"
                    echo 'Connecting to Droplet and deploying...'
                    sshagent([SSH_CREDENTIALS]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no root@${DROPLET_IP} '
                                if ! command -v docker &> /dev/null; then
                                    echo "Installing Docker..."
                                    apt-get update && apt-get install -y docker.io
                                fi
                                echo "Pulling Docker image..."
                                docker pull ${image_name}
                                echo "Running the container..."
                                docker stop java-web-app || true && docker rm java-web-app || true
                                docker run -d --name java-web-app -p 80:8080 ${image_name}
                            '
                        """
                    }
                }
            }
        }
    }
}