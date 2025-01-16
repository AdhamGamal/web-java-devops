# Web Application Overview

This repository contains a Java-based web application built using Maven. The application is structured to enable efficient development and deployment using DevOps practices. Below is a detailed overview of the project, its structure, and how to set it up as a DevOps developer.

---

## Images
|Root|Servlet|
|---|---|
|<img width="427" alt="image" src="https://github.com/user-attachments/assets/73da303e-2843-48e2-a81d-46441254a915" />|<img width="306" alt="image" src="https://github.com/user-attachments/assets/58fa8278-598d-4c63-bfb6-ef0c72f11674" />|

---

## Project Structure

```
web-java-devops/
├── src/
│   ├── main/
│   │   ├── java/            # Java source files
│   │   ├── resources/       # Configuration files
│   │   └── webapp/          # Web application files (HTML, JSP, etc.)
│   └── test/                # Test cases
├── pom.xml                  # Maven configuration file
├── Dockerfile               # Dockerfile for containerizing the application
├── Jenkinsfile              # Jenkins pipeline script
└── README.md                # Project documentation
```
---

## Running the Application Locally Using Jetty

To test the application locally, you can use the Jetty server, which is lightweight and easy to configure.

### Steps to Run:

1. Ensure that Maven is installed on your system.
2. Navigate to the project directory:
   ```
   cd web-java-devops
   ```
3. Use the Maven Jetty plugin to start the server:
   ```
   mvn jetty:run
   ```
4. Once the server starts, access the application in your browser at:
   ```
   http://localhost:9090
   ```

This step ensures the application runs successfully before moving to deployment automation.

---

## Objective as a DevOps Developer

The goal is to implement a CI/CD pipeline using Jenkins to automate the following:

1. Cloning the repository.
2. Building the application (WAR file) using Maven.
3. Building a Docker image for the application.
4. Pushing the Docker image to Docker Hub.
5. Deploying the Docker container to a remote server.

---

## Prerequisites

### 1. Jenkins Setup with Docker-in-Docker (DinD)

To enable Jenkins to build and manage Docker images, we use the **Docker-in-Docker (DinD)** approach as recommended by Jenkins documentation. This allows Jenkins to run Docker commands inside a container without requiring direct access to the host's Docker daemon.

Please follow the documentation here: https://www.jenkins.io/doc/book/installing/docker/#on-macos-and-linux

### 2. Required Credentials

- **Docker Hub Credentials**: Add your Docker Hub username and password as credentials in Jenkins to push Docker images.
- **SSH Credentials**: Add SSH credentials (private key) in Jenkins to enable secure deployment to the remote server.

---

## CI/CD Pipeline Overview

The pipeline consists of the following steps:

1. **Clone Repository**:
   - Fetch the latest code from the GitHub repository.

2. **Build WAR**:
   - Use Maven to clean and package the application into a WAR file.

3. **Extract Version**:
   - Parse the `pom.xml` file to retrieve the application version.

4. **Build Docker Image**:
   - Create a Docker image for the application, tagging it with the retrieved version.

5. **Login to Docker Hub**:
   - Authenticate with Docker Hub using credentials stored in Jenkins.

6. **Push Image to Docker Hub**:
   - Upload the built Docker image to the Docker Hub repository.

7. **Deploy to Remote Server**:
   - Connect to the remote server via SSH.
   - Install Docker on the server if not already installed.
   - Pull the Docker image from Docker Hub.
   - Stop and remove any existing containers running the application.
   - Start a new container with the latest image, mapping the container's port to the server's port.

---

## Post-Build Steps

1. Display a success message with the application version if the pipeline completes successfully.
2. Display a failure message if the pipeline fails at any stage.

---

## Achievements

- Successfully implemented a fully automated CI/CD pipeline using Jenkins.
- Automated the deployment of the application to a remote server using SSH.
- Ensured secure handling of credentials (Docker Hub and SSH) within Jenkins.
- Achieved end-to-end automation from code commit to production deployment.

---

Follow these steps to set up and run the pipeline efficiently. For any issues or further enhancements, please contact me via email at **adhammohamadgamal@gmail.com**.
