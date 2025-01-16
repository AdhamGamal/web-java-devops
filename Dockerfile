# Use a base image with Tomcat or Jetty
FROM tomcat:latest

# Copy the WAR file to the webapps folder
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war