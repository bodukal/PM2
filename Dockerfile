FROM eclipse-temurin:17-jre
VOLUME /tmp
COPY target/ecommerce-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
