FROM maven:3.5.0-jdk-8 as builder
WORKDIR /usr/src/
COPY hello-world/pom.xml  .
RUN mvn dependency:resolve
COPY hello-world  ./hello-world
RUN mvn package -f hello-world/pom.xml

FROM java:8-jdk-alpine
WORKDIR /app
COPY --from=builder /usr/src/hello-world/target/gs-spring-boot-docker-0.1.0.jar app.jar
ENTRYPOINT ["java", "-jar"]
EXPOSE 8080
CMD ["/app/app.jar"]
