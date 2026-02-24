FROM nginx:alpine

RUN apk add --no-cache php83 php83-fpm php83-json

RUN sed -i 's/user = nobody/user = nobody/' /etc/php83/php-fpm.d/www.conf
RUN echo 'clear_env = no' >> /etc/php83/php-fpm.d/www.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY upload.php /usr/share/nginx/html/upload.php

RUN mkdir -p /usr/share/nginx/html/provision
RUN chown -R nobody:nobody /usr/share/nginx/html/provision

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

CMD ["/entrypoint.sh"]