FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libzip-dev libpq-dev libjpeg-dev libpng-dev libxml2-dev libcurl4-openssl-dev libssl-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . .

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer install --no-dev --optimize-autoloader --no-scripts

RUN rm -rf var/cache/*

RUN php bin/console cache:clear --env=prod --no-debug || true

# Aquí creamos las carpetas si no existen y cambiamos el propietario
RUN mkdir -p var vendor && chown -R www-data:www-data var vendor

EXPOSE 80
