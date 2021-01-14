FROM php:7.4-apache

# Basic system software
RUN apt-get update && \
  apt-get install -y --no-install-recommends git zip unzip libgmp-dev curl libzip-dev libonig-dev libpng-dev libjpeg-dev libjpeg62-turbo-dev libxml2-dev && \
  pecl channel-update pecl.php.net && \
  pecl install apcu igbinary && \
  pecl bundle redis && cd redis && phpize && ./configure --enable-redis-igbinary && make && make install && \
  docker-php-ext-enable apcu igbinary opcache redis && \
  docker-php-source delete

# Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Enable apache modules
RUN a2enmod proxy && \
  a2enmod proxy_http && \
  a2enmod proxy_ajp && \
  a2enmod rewrite && \
  a2enmod deflate && \
  a2enmod headers && \
  a2enmod proxy_balancer && \
  a2enmod proxy_connect && \
  a2enmod ssl && \
  a2enmod cache && \
  a2enmod expires

# GD
RUN docker-php-ext-configure gd --with-jpeg

# Install MS ODBC Driver for SQL Server
RUN apt-get update && apt-get install -y gnupg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 --no-install-recommends
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools --no-install-recommends
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
# RUN source ~/.bashrc
RUN apt-get install -y unixodbc-dev --no-install-recommends
RUN apt-get install -y libgssapi-krb5-2 --no-install-recommends

# Install SQLSRV module
RUN pecl channel-update pecl.php.net
RUN pecl install sqlsrv 
RUN pecl install pdo_sqlsrv 
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# Install remaining php modules
RUN docker-php-ext-install gmp mbstring pdo zip intl mysqli pdo pdo_mysql sockets gd soap xml dom

# Install imagick
RUN apt-get update && apt-get install -y \
  libmagickwand-dev --no-install-recommends \
  && pecl install imagick \
  && docker-php-ext-enable imagick

# PHP configs for Apache
RUN echo "memory_limit = 1024M" > /usr/local/etc/php/conf.d/rms-php.ini
RUN echo "date.timezone = Europe/Zurich" > /usr/local/etc/php/conf.d/rms-php.ini

WORKDIR /var/www/html

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]