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

# Cambia el DocumentRoot para que Apache sirva desde /var/www/html/public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Añade ServerName para evitar warning de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Instala Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instala dependencias sin dev y optimiza autoload
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Borra caché previa si existiera
RUN rm -rf var/cache/*

# Genera caché Symfony para producción (no falla si da error)
RUN php bin/console cache:clear --env=prod --no-debug || true

# Cambia el propietario al usuario www-data de Apache
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

# Expone el puerto 80
EXPOSE 80
