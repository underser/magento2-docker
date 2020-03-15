FROM php:7.3-fpm-stretch

MAINTAINER Roman Sliusar <roman.slusar95@gmail.com>

RUN apt-get update && apt-get install -y \
  cron \
  git \
  gzip \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libxslt1-dev \
  lsof \
  mysql-client \
  vim \
  libzip-dev \
  zip

RUN docker-php-ext-configure zip --with-libzip && docker-php-ext-install zip

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  bcmath \
  gd \
  intl \
  mbstring \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip \
  sockets

RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

RUN apt-get update && apt-get -t stretch-backports install -y \
  libsodium-dev

RUN pecl install -f libsodium-1.0.17

RUN pecl channel-update pecl.php.net \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN apt-get install -y libssh2-1-dev \
  && git clone https://git.php.net/repository/pecl/networking/ssh2.git /tmp/ssh2 \
  && cd /tmp/ssh2 \
  && ./.travis/build.sh \
  && docker-php-ext-enable ssh2

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get install -y gnupg \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs \
  && mkdir /var/www/.config /var/www/.npm \
  && chown www-data:www-data /var/www/.config /var/www/.npm \
  && ln -s /var/www/html/node_modules/grunt/bin/grunt /usr/bin/grunt

RUN curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x mhsendmail_linux_amd64 \
  && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN printf '* *\t* * *\tapp\t%s/usr/local/bin/php /var/www/html/update/cron.php\n' >> /etc/crontab
RUN printf '* *\t* * *\tapp\t%s/usr/local/bin/php /var/www/html/bin/magento cron:run\n' >> /etc/crontab
RUN printf '* *\t* * *\tapp\t%s/usr/local/bin/php /var/www/html/bin/magento setup:cron:run\n#\n' >> /etc/crontab

COPY ./config/www.conf /usr/local/etc/php-fpm.d/
COPY ./config/php.ini /usr/local/etc/php/
COPY ./config/php-fpm.conf /usr/local/etc/
COPY bin/cronstart /usr/local/bin/

RUN mkdir -p /etc/nginx/html /var/www/html /sock
RUN chown -R www-data:www-data /etc/nginx /etc/nginx/html /var/cache/nginx/ /var/www /usr/local/etc/php/conf.d /sock

USER www-data:www-data

VOLUME /var/www

WORKDIR /var/www/html

EXPOSE 9001