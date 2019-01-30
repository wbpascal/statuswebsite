FROM gradle:5.1-jdk8-alpine
USER root
WORKDIR /opt/app

COPY gradle/ gradle/
COPY src/ src/

COPY build.gradle build.gradle
COPY gradlew gradlew
COPY settings.gradle settings.gradle

RUN chmod -R 777 /opt/app
# Build and test project
RUN gradle build

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom", "-jar", "build/libs/monitored_service.jar"]
