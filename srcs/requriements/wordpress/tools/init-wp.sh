#!/bin/bash
set -e

# Wait for MariaDB to be ready
echo ">>> Checking MariaDB connectivity..."
until mysqladmin -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ping >/dev/null 2>&1; do
    echo "Wait for MariaDB..."
    sleep 3
done

# Create config for wordpress to connect to mariadb
if [ ! -f "wp-config.php" ]; then
    echo ">>> Downloading WordPress..."
    wp core download --allow-root

    echo ">>> Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb

    echo ">>> Installing WordPress..."
    wp core install --allow-root \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} --skip-email

    echo ">>> Creating WordPress user..."
    wp user create --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author

    echo ">>> WordPress installation complete!"
else
    echo ">>> WordPress already installed."
fi

exec "$@"
