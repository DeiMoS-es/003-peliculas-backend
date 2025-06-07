FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libzip-dev libpq-dev libjpeg-dev libpng-dev libxml2-dev libcurl4-openssl-dev libssl-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . .

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# NO dump-env porque no tienes .env.prod

# Permite que Composer corra como root sin quejarse
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader --no-scripts

RUN rm -rf var/cache/*

RUN php bin/console cache:clear --env=prod --no-debug || true

RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

EXPOSE 80
