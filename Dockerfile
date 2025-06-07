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

# Copia el código fuente
COPY . /var/www/html/

# Crea un usuario sin privilegios
RUN useradd -m symfonyuser

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Cambia propietario de los archivos para que symfonyuser pueda escribir
RUN chown -R symfonyuser:symfonyuser /var/www/html

# Usa el usuario sin privilegios
USER symfonyuser

# Instala dependencias
RUN composer install --no-dev --optimize-autoloader

# Volvemos al usuario www-data para ejecución de Apache
USER www-data

# Expone el puerto 80
EXPOSE 80

# Comando por defecto
CMD ["apache2-foreground"]
