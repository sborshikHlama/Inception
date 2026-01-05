#!/bin/bash
set -e

echo ">>> Starting MariaDB initialization..."

if [ ! -d "/var/lib/mysql" ]; then
	echo ">>> Initializing empty database directory..."
	mysql --initialize-insecure
fi

echo ">>> Starting MariaDB temporarily for setup..."
mysqld --skip-networking --skip-grant-tables &
MYSQLD_PID=$!

echo ">>> Waiting for MariaDB to be ready..."
until mysql -u root -e "SELECT 1" >/dev/null 2>&1; do
    sleep 1
done

echo ">>> Setting root password..."
mysql -u root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

if [ -n "$MYSQL_DATABASE" ]; then
    echo ">>> Creating database: $MYSQL_DATABASE"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
EOSQL
fi

if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
    echo ">>> Creating user: $MYSQL_USER"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL
fi

# Shut down the temporary MariaDB instance
echo ">>> Shutting down temporary MariaDB..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Wait for it to fully stop
wait $MYSQLD_PID

echo ">>> MariaDB initialization complete!"