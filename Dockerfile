# Usamos PHP 8.3 con Apache
FROM php:8.3-apache

# Instalamos dependencias del sistema y extensiones PHP necesarias para Symfony
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libzip-dev libpq-dev libjpeg-dev libpng-dev libxml2-dev libcurl4-openssl-dev libssl-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Activamos mod_rewrite para Apache
RUN a2enmod rewrite

# Creamos usuario y grupo sin privilegios (uid y gid 1000)
RUN groupadd -g 1000 appuser && useradd -u 1000 -g appuser -m appuser

# Establecemos directorio de trabajo
WORKDIR /var/www/html

# Copiamos los archivos necesarios para la instalación de dependencias
COPY composer.json composer.lock ./

# Copiamos composer desde la imagen oficial de composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Cambiamos propietario del directorio de trabajo para appuser
RUN chown -R appuser:appuser /var/www/html

# Cambiamos a usuario appuser para evitar problemas de permisos y ejecución como root
USER appuser

# Instalamos dependencias PHP sin dev y con autoloader optimizado
RUN composer install --no-dev --optimize-autoloader

# Volvemos a root para continuar con tareas de sistema y copiar el resto de archivos
USER root

# Copiamos el resto del proyecto, excluyendo la carpeta vendor
COPY . .

# Ajustamos permisos de carpetas que Symfony necesita para escribir
RUN mkdir -p var/cache var/log var/sessions vendor && \
    chown -R www-data:www-data var vendor

# Limpiamos caché de Symfony (modo prod y sin debug), forzando que no falle el build si hay error
RUN php bin/console cache:clear --env=prod --no-debug || true

# Copiamos configuración apache personalizada
COPY apache/vhost.conf /etc/apache2/sites-available/000-default.conf

# Exponemos el puerto 80
EXPOSE 80

# Arrancamos Apache en primer plano
CMD ["apache2-foreground"]
