FROM bellsoft/liberica-openjdk-centos:8u232-10
ARG adminuser=admin

ADD ./bellsoft-tomee-plus8.noarch.rpm /bellsoft-tomee-plus8.noarch.rpm

RUN rpm -ivh --nodeps /bellsoft-tomee-plus8.noarch.rpm

ENV PATH /opt/bellsoft/tomee/8.0.0/bin/:$PATH

WORKDIR /opt/bellsoft/tomee/8.0.0/
# RUN rm -rf webapps/
# RUN rm -rf apps/


# not necessary if everything was deleted (command RUN rm -f)
COPY tomee/context.xml webapps/manager/META-INF/

COPY target/*.war webapps/ROOT.war

CMD ["catalina.sh","run"]

EXPOSE 8080