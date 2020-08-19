FROM tomee:11-jre-8.0.2-webprofile

RUN rm -rf /usr/local/tomee/webapps/

COPY target/*.war /usr/local/tomee/webapps/ROOT.war

EXPOSE 8080