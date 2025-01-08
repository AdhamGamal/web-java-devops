# Web Application Overview

This repository contains a Java-based web application built using Maven. The application is structured to enable efficient development and deployment using DevOps practices. Below is a detailed overview of the project, its structure, and how to set it up as a DevOps developer.

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
5. Deploying the Docker container to a server.

---

## Prerequisites

### 1. Create a Jenkins Container

Run the following command to set up a Jenkins container:

```
docker run -d \
  --name jenkins \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  -v $(which docker):/usr/bin/docker \
  -p 8080:8080 \
  -p 50000:50000 \
  jenkins/jenkins:lts
```

#### Why Use These Volumes and Privileges?

- `--privileged`: Allows Jenkins to access the Docker daemon on the host machine.
- `-v /var/run/docker.sock:/var/run/docker.sock`: Enables Jenkins to communicate with Docker for building and managing images.
- `-v $(which docker):/usr/bin/docker`: Provides access to the Docker CLI within the container.
- `-v jenkins_home:/var/jenkins_home`: Persists Jenkins data, such as configurations and build logs.

### 2. Configure the Jenkins Container

Open the Jenkins container using the following command:

```
docker exec -u 0 -it jenkins bash
```

#### Perform the Following Steps Inside the Container:

1. Update permissions for Docker socket:

   ```
   chmod 666 /var/run/docker.sock
   ```

   - This allows non-root users (like the `jenkins` user) to access the Docker daemon.

2. Install Maven:

   ```
   apt-get update && apt-get install -y maven
   ```

   - Maven is required to build the Java application within the pipeline.

3. Retrieve the Jenkins initial admin password:

   ```
   cat /var/jenkins_home/secrets/initialAdminPassword
   ```

   - Use this password to complete the Jenkins setup in your browser at `http://<your_server_ip>:8080`.

---

## Setting Up Jenkins

1. Access Jenkins through your browser (`http://<your_server_ip>:8080`) and complete the setup using the initial admin password.
2. Install suggested plugins.
3. Create a new pipeline job.
4. Add Docker Hub credentials in Jenkins (ID: `DockerHub`).

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

---

## Post-Build Steps

1. Cleaning up cloned project files.
2. Logout from Docker Hub to ensure security.
3. Display a success message with the application version if the pipeline completes successfully.
4. Display a failure message if the pipeline fails at any stage.

---

Follow these steps to set up and run the pipeline efficiently. For any issues or further enhancements, refer to the Jenkins logs and documentation.

