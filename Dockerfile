FROM tomee:11-jre-8.0.2-webprofile

COPY target/*.war /usr/local/tomee/webapps/ROOT.war

EXPOSE 8080