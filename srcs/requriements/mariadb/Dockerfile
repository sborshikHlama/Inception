FROM alpine:3.19

# Install MariaDB and client, no cache to keep image small
RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb mariadb-client && \
    rm -rf /var/cache/apk/*

# Create required directories and set permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld /docker-entrypoint-initdb.d && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql --basedir=/usr

# Copy custom MariaDB config
COPY ./conf/50-server.cnf /etc/my.cnf.d/50-server.cnf

# Copy initialization script
COPY ./tools/init-db.sh /docker-entrypoint-initdb.d/init-db.sh

# Make script executable
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Expose MySQL/MariaDB port
EXPOSE 3306

# Start MariaDB (this is the command that runs when container starts)
CMD ["mysqld", "--user=mysql", "--console"]