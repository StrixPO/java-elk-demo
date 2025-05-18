# Use Tomcat base image
FROM tomcat:9.0-jdk11

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy our WAR into webapps
COPY sample.war /usr/local/tomcat/webapps/ROOT.war

# Expose port (Tomcat default)
EXPOSE 8080

