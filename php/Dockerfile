FROM php:8.2-fpm-buster

MAINTAINER Roman Sliusar <roman.slusar95@gmail.com>

RUN apt-get update && apt-get install -y \
  cron \
  git \
  gzip \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libsodium-dev \
  libonig-dev \
  libpng-dev \
  libxslt1-dev \
  lsof \
  default-mysql-client \
  vim \
  libzip-dev \
  zip \
  mailutils \
  msmtp

RUN docker-php-ext-configure \
  gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

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
  sockets \
  sodium \
  zip

RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

RUN pecl channel-update pecl.php.net \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN apt-get install -y libssh2-1-dev \
  && git clone https://github.com/php/pecl-networking-ssh2.git /tmp/ssh2 \
  && cd /tmp/ssh2 \
  && ./.travis/build.sh \
  && docker-php-ext-enable ssh2

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get install -y gnupg \
  && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && mkdir /var/www/.config /var/www/.npm \
  && chown www-data:www-data /var/www/.config /var/www/.npm \
  && ln -s /var/www/html/node_modules/grunt/bin/grunt /usr/bin/grunt

RUN curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x mhsendmail_linux_amd64 \
  && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN pecl install redis \
  && docker-php-ext-enable redis

RUN apt-get install -y libmagickwand-dev \
  && pecl install imagick  \
  && docker-php-ext-enable imagick

RUN printf '* *\t* * *\tapp\t%s/usr/local/bin/php /var/www/html/update/cron.php\n' >> /etc/crontab
RUN printf '* *\t* * *\tapp\t%s/usr/local/bin/php /var/www/html/bin/magento cron:run\n' >> /etc/crontab
RUN printf '* *\t* * *\tapp\t%s/usr/local/bin/php /var/www/html/bin/magento setup:cron:run\n#\n' >> /etc/crontab

COPY ./config/www.conf /usr/local/etc/php-fpm.d/
COPY ./config/msmtprc /etc/msmtprc
COPY ./config/php.ini /usr/local/etc/php/
COPY ./config/php-fpm.conf /usr/local/etc/
COPY bin/cronstart /usr/local/bin/

RUN mkdir -p /etc/nginx/html /var/cache/nginx/ /var/www/html /sock
RUN chown -R www-data:www-data /etc/nginx /etc/nginx/html /var/cache/nginx/ /var/www /usr/local/etc/php/conf.d /sock

USER www-data:www-data

VOLUME /var/www

WORKDIR /var/www/html

EXPOSE 9001