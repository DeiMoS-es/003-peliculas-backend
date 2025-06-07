# Usa una imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instala extensiones necesarias de PHP
RUN apt-get update && apt-get install -y \
    git zip unzip curl libicu-dev libonig-dev libzip-dev libpng-dev libxml2-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Habilita Apache mod_rewrite
RUN a2enmod rewrite

# Cambia el DocumentRoot de Apache a /var/www/html/public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Copia el código al contenedor
COPY . /var/www/html/

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Ajusta permisos
RUN mkdir -p var vendor && chown -R www-data:www-data var vendor

# Expone el puerto 80
EXPOSE 80

# Instala las dependencias PHP (si composer.lock existe)
RUN if [ -f composer.json ]; then composer install; fi
