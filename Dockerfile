# Use a lightweight OpenJDK base image
FROM openjdk:11-jre-slim

# Add a volume pointing to /tmp
VOLUME /tmp

# Copy the packaged jar file into the container
COPY target/ecommerce-1.0-SNAPSHOT.jar app.jar

# Expose the port your app runs on (default 8080)
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java","-jar","/app.jar"]
