# Use a base image with Tomcat or Jetty
FROM tomcat:9.0

# Remove default web apps to clean the image
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file to the webapps folder
COPY target/simple-web-page.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port that Tomcat/Jetty will run on
EXPOSE 8080

# Run Tomcat in the background
CMD ["catalina.sh", "run"]