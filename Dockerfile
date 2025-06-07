# Imagen base oficial de PHP con Apache
FROM php:8.3-apache

# Instala extensiones necesarias para Symfony
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libzip-dev libpq-dev libjpeg-dev libpng-dev libxml2-dev libcurl4-openssl-dev libssl-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Habilita el módulo Apache Rewrite
RUN a2enmod rewrite

# Establece directorio de trabajo
WORKDIR /var/www/html

# Copia archivos del proyecto Symfony
COPY . .

# Instala Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Compila entorno de producción (como root, permitiendo plugins)
RUN COMPOSER_ALLOW_SUPERUSER=1 composer dump-env prod

# Instala dependencias en modo producción sin scripts post-install (como @auto-scripts)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Borra caché previa si existiera
RUN rm -rf var/cache/*

# Genera caché Symfony para producción
RUN php bin/console cache:clear --env=prod --no-debug || true

# Cambia el propietario al usuario de Apache
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

# Exponer el puerto 80
EXPOSE 80
