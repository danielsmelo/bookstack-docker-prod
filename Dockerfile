FROM composer:latest as composerreqs

WORKDIR /reqs
COPY /BookStack ./bookstack-composer
WORKDIR /reqs/bookstack-composer

RUN apk update \
    && apk add git zip unzip libpng-dev libzip-dev
RUN docker-php-ext-install gd

RUN composer install --no-dev --no-plugins

FROM node:lts as packages

WORKDIR /packages
COPY --from=composerreqs /reqs/bookstack-composer ./bookstack-node
WORKDIR /packages/bookstack-node

RUN npm install && npm run production

FROM php:7.4-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
ARG DOMAIN_URL=localhost:9876

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html

RUN apt-get update -y \
    && apt-get install -y git zip unzip libpng-dev libldap2-dev libzip-dev wait-for-it \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install pdo_mysql gd ldap zip
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash \
    && apt-get install nodejs

COPY --from=packages /packages/bookstack-node/ .

RUN cp .env.example .env \
    && sed -i.bak "s@APP_URL=.*\$@APP_URL=http://${DOMAIN_URL}@" .env

RUN php artisan key:generate --no-interaction --force
RUN chown www-data:www-data -R bootstrap/cache public/uploads storage && chmod -R 755 bootstrap/cache public/uploads storage
RUN a2enmod rewrite

