FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update

RUN apt-get install -y wget gnupg2 || apt-get install -y gnupg

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.12
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates 


RUN wget -O - http://repo.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO | apt-key add - && \
echo deb http://repo.postgrespro.ru//pgpro-archive/pgpro-12.2.1/debian buster main > /etc/apt/sources.list.d/postgrespro-std.list && \
apt-get update -y && \
apt-get install -y postgrespro-std-12-server postgrespro-std-12-dev && \
/opt/pgpro/std-12/bin/pg-setup initdb && \
/opt/pgpro/std-12/bin/pg-setup service enable

RUN apt-get install -y git make gcc build-essential

ENV PATH="/opt/pgpro/std-12/bin:${PATH}"

# 
#	pg_audit
#
RUN git clone https://github.com/pgaudit/pgaudit.git && \
	cd ./pgaudit && \
	git checkout REL_12_STABLE && \
	make check USE_PGXS=1 && \
	make install USE_PGXS=1 

COPY conf/pgaudit.conf /tmp/
RUN cat /tmp/pgaudit.conf >> /var/lib/pgpro/std-12/data/postgresql.conf && rm -f /tmp/pgaudit.conf


# 
#	direct login for eko
#
RUN git clone https://github.com/splendiddata/login_hook.git && \
	cd ./login_hook && \
	make && \
	make install 

COPY conf/pg_login_hook.conf /tmp/
RUN cat /tmp/pg_login_hook.conf >> /var/lib/pgpro/std-12/data/postgresql.conf && rm -f /tmp/pg_login_hook.conf

#
#	password to scram-sha-256
#
COPY conf/pg_password.conf /tmp/
RUN cat /tmp/pg_password.conf >> /var/lib/pgpro/std-12/data/postgresql.conf && rm -f /tmp/pg_password.conf

#
#   set password for postgres(no needed in prod)
#
RUN /etc/init.d/postgrespro-std-12 start && \
# crunch todo
sed -i "s|peer|trust|g" /var/lib/pgpro/std-12/data/pg_hba.conf && \
gosu postgres psql --command "ALTER USER postgres WITH PASSWORD '4321';" 

#COPY conf/pg_hba.conf /var/lib/pgpro/std-12/data/pg_hba.conf
# only for docker
RUN echo "host all  all    0.0.0.0/0  scram-sha-256" >> /var/lib/pgpro/std-12/data/pg_hba.conf

COPY conf/postgresql.localhost.conf /tmp/
RUN cat /tmp/postgresql.localhost.conf >> /var/lib/pgpro/std-12/data/postgresql.conf && rm -f /tmp/postgresql.localhost.conf



CMD ["gosu", "postgres", "/opt/pgpro/std-12/bin/postgres","-D", "/var/lib/pgpro/std-12/data"]

EXPOSE 5432
