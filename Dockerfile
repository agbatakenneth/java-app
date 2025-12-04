#Build Stage
FROM maven:3.9.6-eclipse-temurin-17 AS build 
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Run Stage
FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=build /app/target/*.jar /app/
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app/tech365-0.0.1-SNAPSHOT.jar"]