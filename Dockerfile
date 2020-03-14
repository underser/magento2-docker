FROM nginx:1.13

MAINTAINER Roman Sliusar <roman.sliusar95@gmail.com>

RUN touch /var/run/nginx.pid
RUN mkdir /sock

RUN apt-get update && apt-get install -y openssl && apt-get install -y vim
RUN mkdir /etc/nginx/certs \
  && echo -e "\n\n\n\n\n\n\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt

COPY ./.docker/config/nginx.conf /etc/nginx/
COPY ./.docker/config/default.conf /etc/nginx/conf.d/
COPY ./.docker/config/magento.conf /etc/nginx/conf.d/

RUN mkdir -p /etc/nginx/html /var/www/html \
  && chown -R www-data:www-data /etc/nginx /var/www /var/cache/nginx /var/run/nginx.pid /sock

EXPOSE 8443

USER www-data:www-data

VOLUME /var/www

WORKDIR /var/www/html
