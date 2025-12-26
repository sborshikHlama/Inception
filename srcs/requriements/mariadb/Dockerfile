FROM alpine: 3.12

RUN apk update && apk upgrade && apk add mariadb-server

COPY ./conf/server.conf /etc/mysql/mariadb.conf.d/50-server.cnf