FROM jenkins/jenkins:lts-jdk11
COPY --chown=jenkins:jenkins jenkins.jks /var/lib/jenkins/jenkins.jks
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/lib/jenkins/jenkins.jks --httpsKeyStorePassword=password
EXPOSE 8083

