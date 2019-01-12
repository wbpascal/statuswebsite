FROM openjdk:8u181-jdk-alpine

WORKDIR /app

COPY gradle/ gradle/
COPY src/ src/

COPY build.gradle build.gradle
COPY gradlew gradlew
COPY settings.gradle settings.gradle

# Build and test project
RUN ./gradlew build

CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "build/libs/influxdb_listener.jar"]
