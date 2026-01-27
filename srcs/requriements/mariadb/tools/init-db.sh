#!/bin/bash
set -e

echo ">>> Starting MariaDB initialization..."

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">>> Initializing empty database directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo ">>> Starting MariaDB temporarily for setup..."
mysqld --user=mysql --skip-networking &
MYSQLD_PID=$!

echo ">>> Waiting for MariaDB to be ready..."
until mysqladmin ping >/dev/null 2>&1; do
    sleep 1
done

echo ">>> Running SQL commands..."
mysql -u root <<EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

echo ">>> Shutting down temporary MariaDB..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Wait for it to fully stop
wait $MYSQLD_PID

echo ">>> MariaDB initialization complete!"

exec "$@"