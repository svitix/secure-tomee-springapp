FROM bellsoft/liberica-openjdk-centos:8u232-10
ARG ADMIN_USER=admin
ARG ADMIN_PASSWORD=newpassword

ADD ./bellsoft-tomee-plus8.noarch.rpm /bellsoft-tomee-plus8.noarch.rpm

RUN rpm -ivh --nodeps /bellsoft-tomee-plus8.noarch.rpm

RUN rm /bellsoft-tomee-plus8.noarch.rpm

ENV PATH /opt/bellsoft/tomee/8.0.0/bin/:$PATH

WORKDIR /opt/bellsoft/tomee/8.0.0/


COPY tomee/tomcat-users.xml conf/tomcat-users.xml
RUN sed -i "s|tomeeuser|$ADMIN_USER|g" conf/tomcat-users.xml
RUN sed -i "s|tomeepassword|$(bin/digest.sh -a "sha-256" -s 0 $ADMIN_PASSWORD | cut -d ":" -f2)|g" conf/tomcat-users.xml

COPY tomee/server.xml conf/server.xml
COPY tomee/web.xml conf/web.xml


# RUN rm -rf webapps/
# RUN rm -rf apps/

# not necessary if everything was deleted (command RUN rm -f)
COPY tomee/context-manager.xml webapps/manager/META-INF/context.xml

COPY target/*.war webapps/demo.war

CMD ["catalina.sh","run"]

EXPOSE 8080
EXPOSE 8005