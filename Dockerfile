FROM tomee:11-jre-8.0.2-webprofile

RUN rm -rf /usr/local/tomee/webapps/

COPY target/*.war /usr/local/tomee/webapps/ROOT.war

# not necessary if everything was deleted (command RUN rm -f) 
COPY tomee/context.xml /usr/local/tomee/webapps/manager/META-INF/

EXPOSE 8080