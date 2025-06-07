FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libzip-dev libpq-dev libjpeg-dev libpng-dev libxml2-dev libcurl4-openssl-dev libssl-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

RUN a2enmod rewrite

WORKDIR /var/www/html

# Copiar solo archivos para instalar dependencias
COPY composer.json composer.lock ./

# Copiar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalar dependencias (symfony/runtime incluido)
RUN composer install --no-dev --optimize-autoloader

# Copiar el resto del proyecto, excluyendo vendor
COPY . .

RUN rm -rf var/cache/*

RUN mkdir -p var/cache var/log var/sessions && chown -R www-data:www-data var

RUN php bin/console cache:clear --env=prod --no-debug || true

COPY apache/vhost.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]
