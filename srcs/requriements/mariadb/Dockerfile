FROM alpine:3.19

# Install MariaDB and client, no cache to keep image small
RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb mariadb-client bash && \
    rm -rf /var/cache/apk/*

# Create required directories and set permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# Copy custom MariaDB config
COPY ./conf/50-server.cnf /etc/my.cnf.d/50-server.cnf

# Copy initialization script
COPY ./tools/init-db.sh /usr/local/bin/init-db.sh

# Make script executable
RUN chmod +x /usr/local/bin/init-db.sh

# Expose MySQL/MariaDB port
EXPOSE 3306

# Start MariaDB via the initialization script
ENTRYPOINT ["/usr/local/bin/init-db.sh"]
CMD ["mysqld", "--user=mysql", "--console"]