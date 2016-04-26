FROM frolvlad/alpine-oraclejdk8:slim
VOLUME /tmp
ADD quickstart-java-1.0.1.war app.jar
RUN sh -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]