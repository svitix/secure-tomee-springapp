FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update


RUN apt-get install -y wget gnupg2 || apt-get install -y gnupg && \
wget -O - http://repo.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO | apt-key add - && \
echo deb http://repo.postgrespro.ru//pgpro-archive/pgpro-12.2.1/debian buster main > /etc/apt/sources.list.d/postgrespro-std.list && \
apt-get update -y && \
apt-get install -y postgrespro-std-12-server postgrespro-std-12-dev && \
/opt/pgpro/std-12/bin/pg-setup initdb && \
/opt/pgpro/std-12/bin/pg-setup service enable

RUN apt-get install -y git make gcc build-essential

RUN git clone https://github.com/pgaudit/pgaudit.git && \
	cd ./pgaudit && \
	git checkout REL_12_STABLE && \
	export PATH=$PATH:/opt/pgpro/std-12/bin/ && \
	make check USE_PGXS=1 && \
	make install USE_PGXS=1 


USER postgres

CMD ["/opt/pgpro/std-12/bin/postgres", "-D", "/var/lib/pgpro/std-12/data"]

EXPOSE 5432
