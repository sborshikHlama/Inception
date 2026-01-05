FROM alpine:3.19

RUN apk update && apk upgrade && apk add nginx 

RUN mkdir -p /etc/nginx/ssl

RUN apk add openssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=aevstign.42.fr/UID=aevstign"

RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html && \
    chmod 755 /var/www/html && \
    chown -R nginx:nginx /var/www/html

CMD [ "nginx", "-g", "daemon off;" ]
