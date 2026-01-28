FROM alpine:3.19

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-phar \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-redis \
    wget \
    curl \
    bash \
    mariadb-client

# Download wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# PHP-FPM configuration to listen on port 9000 instead of local socket
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

# Increase PHP memory limit
RUN echo "memory_limit=512M" > /etc/php82/conf.d/memory-limit.ini

# Create the directory for the socket and set permissions
RUN mkdir -p /run/php && \
    chown -R root:root /run/php

WORKDIR /var/www/html

COPY tools/init-wp.sh /usr/local/bin/init-wp.sh
RUN chmod +x /usr/local/bin/init-wp.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init-wp.sh"]
CMD ["/usr/sbin/php-fpm82", "-F"]
