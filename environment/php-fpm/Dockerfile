FROM php:8.2-fpm

WORKDIR /var/www

EXPOSE 9000

#-----------------------------------------------------------------------------------------------------------------------
# Setting environment variables
#-----------------------------------------------------------------------------------------------------------------------
ENV TIME_ZONE="America/Sao_Paulo" \
    TZ="America/Sao_Paulo" \
    ACCEPT_EULA=Y \
    DEBIAN_FRONTEND=noninteractive

RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo "America/Sao_Paulo" > /etc/timezone; exit 0;


#-----------------------------------------------------------------------------------------------------------------------
# Install system dependencies
#-----------------------------------------------------------------------------------------------------------------------
RUN apt update && apt install -y --no-install-recommends apt-transport-https \
    apt-utils \
    autoconf \
    curl \
    g++ \
    git \
    gnupg \
    krb5-kdc \
    libc-client-dev \
    libc-client2007e-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libmcrypt-dev \
    libpng-dev \
    libpq-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libzip-dev \
    locales \
    make \
    musl \
    openssl \
    vim \
    nano \
    bash \
    inetutils-traceroute \
    net-tools \
    telnet \
    tree \
    certbot \
    nmap \
    unixodbc-dev \
    unzip \
    wget \
    zip \
    libsodium-dev \
    libmemcached-dev \
    zlib1g-dev \
    freetds-bin \
    freetds-dev \
    freetds-common && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen;


#-----------------------------------------------------------------------------------------------------------------------
# Configure PHP extension for installation
#-----------------------------------------------------------------------------------------------------------------------
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-configure gd --with-jpeg --with-freetype


#-----------------------------------------------------------------------------------------------------------------------
# Install Docker-PHP Extensions, php 8.x and it's dependencies
#-----------------------------------------------------------------------------------------------------------------------
RUN docker-php-ext-install bcmath \
    gd \
    intl \
    imap > /dev/null \
    pcntl \
    pgsql \
    pdo_pgsql\
    pdo_dblib \
    opcache \
    ldap \
    pdo \
    soap \
    pdo_mysql \
    sodium \
    zip \
    pdo_dblib

#-----------------------------------------------------------------------------------------------------------------------
# Install Docker-PHP Extensions via PECL
#-----------------------------------------------------------------------------------------------------------------------
## update pecl channel
RUN pecl channel-update pecl.php.net

RUN pecl install --onlyreqdeps --nobuild openswoole && \
    cd "$(pecl config-get temp_dir)/openswoole" && \
    phpize && \
    ./configure --enable-openssl --enable-http2 --enable-swoole-curl --enable-swoole-json && \
    make && make install

RUN pecl install sqlsrv pdo_sqlsrv igbinary mongodb apcu msgpack memcached

RUN pecl install -D 'enable-redis-igbinary="yes"' redis


#-----------------------------------------------------------------------------------------------------------------------
# This PHP extension enables the SQL-Server Dependencies
#-----------------------------------------------------------------------------------------------------------------------
RUN rm -f /etc/apt/sources.list.d/mssql-release.list && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update -y && apt-get upgrade -y && \
    ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated msodbcsql17 && \
    ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated mssql-tools


#-----------------------------------------------------------------------------------------------------------------------
# Enabling PHP docker-extensions
#-----------------------------------------------------------------------------------------------------------------------
RUN docker-php-ext-enable ldap \
    igbinary \
    mongodb.so \
    apcu --ini-name 10-docker-php-ext-apcu.ini \
    msgpack \
    memcached \
    openswoole \
    redis \
    bcmath \
    gd \
    intl \
    imap > /dev/null \
    pcntl \
    pdo \
    sqlsrv \
    pgsql \
    pdo_sqlsrv \
    pdo_mysql \
    pdo_pgsql\
    opcache \
    soap \
    sodium \
    zip


#-----------------------------------------------------------------------------------------------------------------------
# COPY needed files
#-----------------------------------------------------------------------------------------------------------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


#-----------------------------------------------------------------------------------------------------------------------
# CLEAN CACHE AND TEMP FILES
#-----------------------------------------------------------------------------------------------------------------------
RUN apt-get clean && \
    pecl clear pecl clear-cache && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


#-----------------------------------------------------------------------------------------------------------------------
# PHP signals handler -  https://www.php.net/manual/pt_BR/function.pcntl-signal.php
# https://www.google.com/search?q=php+handle+sigterm+and+sigquit
#-----------------------------------------------------------------------------------------------------------------------
STOPSIGNAL SIGINT