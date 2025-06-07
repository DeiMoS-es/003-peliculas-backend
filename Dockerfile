# Usa una imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instala extensiones necesarias
RUN apt-get update && apt-get install -y \
    git zip unzip libicu-dev libonig-dev libzip-dev libpng-dev libxml2-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Habilita Apache mod_rewrite
RUN a2enmod rewrite

# Copia el código al contenedor
COPY . /var/www/html/

# Establece el working dir
WORKDIR /var/www/html

# Ajusta permisos
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

# Expone el puerto 80 (por Apache)
EXPOSE 80
