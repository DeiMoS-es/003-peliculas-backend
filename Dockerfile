# Usa una imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instala extensiones necesarias de PHP
RUN apt-get update && apt-get install -y \
    git zip unzip curl libicu-dev libonig-dev libzip-dev libpng-dev libxml2-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Habilita Apache mod_rewrite
RUN a2enmod rewrite

# Cambia DocumentRoot a /var/www/html/public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Instala Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Copia el código al contenedor
COPY . /var/www/html/

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Ajusta permisos para que www-data tenga acceso (Apache)
RUN mkdir -p var vendor && chown -R www-data:www-data var vendor

# Crea un usuario sin privilegios y cambia a él
RUN useradd -m symfonyuser

USER symfonyuser

# Instala dependencias con composer como usuario no root
RUN if [ -f composer.json ]; then composer install --no-dev --optimize-autoloader; fi

# Cambia a usuario www-data para que Apache pueda leer y escribir lo necesario
USER www-data

# Expone el puerto 80 para Apache
EXPOSE 80

# Comando por defecto (ya está en la imagen php:apache)
CMD ["apache2-foreground"]
