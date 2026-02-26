FROM maven:3.9.12-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package

# FIX: Changed from openjdk:21-jdk to eclipse-temurin:21-jre-alpine
# Using 'jre' and 'alpine' makes the final image much smaller and more secure
FROM eclipse-temurin:21-jre-alpine AS runner
WORKDIR /app

# Note: Ensure the path matches where Maven actually puts the jar
COPY --from=builder /app/target/billing-service-0.0.1-SNAPSHOT.jar ./app.jar

EXPOSE 4001
EXPOSE 9001

ENTRYPOINT ["java", "-jar", "app.jar"]