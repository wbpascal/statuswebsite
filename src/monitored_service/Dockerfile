FROM gradle:jdk8
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

CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "build/libs/monitored_service.jar"]
