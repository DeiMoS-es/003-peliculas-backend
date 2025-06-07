# Usamos PHP 8.3 con Apache
FROM php:8.3-apache

# Instalamos dependencias necesarias para Symfony y extensiones PHP
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libzip-dev libpq-dev libjpeg-dev libpng-dev libxml2-dev libcurl4-openssl-dev libssl-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Activamos mod_rewrite para Apache
RUN a2enmod rewrite

# Establecemos directorio de trabajo
WORKDIR /var/www/html

# Copiamos el proyecto completo a la imagen
COPY . .

# Copiamos Composer para gestionar dependencias PHP
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalamos las dependencias PHP sin dev, con optimización
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Limpiamos cache de Symfony
RUN rm -rf var/cache/*

# Borramos y creamos carpetas necesarias para que no haya errores de permisos
RUN mkdir -p var/cache var/log var/sessions vendor && chown -R www-data:www-data var vendor

# Limpiamos y regeneramos cache en modo producción
RUN php bin/console cache:clear --env=prod --no-debug || true

# Copiamos tu archivo de configuración vhost para Apache
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

# Exponemos puerto 80 para Apache
EXPOSE 80

# Comando para arrancar Apache en primer plano
CMD ["apache2-foreground"]
