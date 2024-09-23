# USING ALPINE AS BASE IMAGE AND CLONING THE REPO
FROM alpine AS git
RUN apk update && apk add git
WORKDIR /usr/java
RUN git clone https://github.com/chaitanya-0799/java-app.git

# BUILDING THE PACKAGE USING MAVEN 
FROM maven:amazoncorretto AS build
WORKDIR /usr/app
COPY --from=git /usr/java/java-app/src ./src
COPY --from=git /usr/java/java-app/pom.xml .
RUN mvn -f /usr/app/pom.xml clean install

# DEPLOYING THE APPLICATION 
FROM openjdk:11-jre-slim
COPY --from=build /usr/app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

