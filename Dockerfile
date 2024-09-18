# Use an official Java runtime as a parent image
FROM openjdk:22-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the local JAR file to the container
COPY target/demo-0.0.1-SNAPSHOT.jar /app/demo.jar

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/app/demo.jar"]
