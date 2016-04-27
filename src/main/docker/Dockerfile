FROM WTF
VOLUME /tmp
ADD quickstart-java-1.0.1.war app.jar
RUN sh -c 'touch /app.jar'
ENTRYPOINT ["java","-Xmx196m", "-Xms196m", "-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]