FROM maven:3.5-jdk-8-alpine

WORKDIR /swagger-petstore
COPY . /swagger-petstore

RUN mvn clean install

FROM openjdk:8-jre-alpine

WORKDIR /swagger-petstore

COPY --from=0 /swagger-petstore/target/lib/jetty-runner.jar /swagger-petstore/jetty-runner.jar
COPY --from=0 /swagger-petstore/target/*.war /swagger-petstore/server.war
COPY src/main/resources/openapi.yaml /swagger-petstore/openapi.yaml
COPY inflector.yaml /swagger-petstore/inflector.yaml

EXPOSE 8080

USER 10014

CMD ["java", "-jar", "-DswaggerUrl=openapi.yaml", "/swagger-petstore/jetty-runner.jar", "/swagger-petstore/server.war"]
