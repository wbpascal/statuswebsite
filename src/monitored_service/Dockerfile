FROM gradle:5.0.0-jdk8-alpine

COPY gradle/ gradle/
COPY src/ src/

COPY build.gradle build.gradle
COPY gradlew gradlew
COPY settings.gradle settings.gradle

RUN gradle assemble

CMD ["gradle", "run"]