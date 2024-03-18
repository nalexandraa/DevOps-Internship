# OpenJDK image as a parent image
FROM openjdk:11

# Set the working directory in the container
WORKDIR /app

# Copy the Java application source code into the container
COPY Main.java .

# Compile the Java application
RUN javac Main.java

# Command to run the Java application
CMD ["java", "Main"]
