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

# Copiamos composer.json y composer.lock para aprovechar cache de Docker
COPY composer.json composer.lock ./

# Copiamos composer desde la imagen oficial
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiamos el resto del proyecto (excluyendo vendor)
COPY . .

# Cambiamos propietario para evitar problemas con permisos
RUN chown -R appuser:appuser /var/www/html

# Cambiamos a usuario sin privilegios para instalar dependencias
USER appuser

# Instalamos dependencias PHP sin dev y con autoloader optimizado (sin scripts para evitar errores)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Ejecutamos los scripts que antes saltaron con error (por tener bin/console disponible ahora)
RUN php bin/console cache:clear --env=prod --no-debug || true

# Volvemos a root para configurar permisos y otras tareas
USER root

# Ajustamos permisos para carpetas que Symfony debe escribir (usamos www-data que es usuario Apache)
RUN mkdir -p var/cache var/log var/sessions vendor && \
    chown -R www-data:www-data var vendor

# Copiamos configuración apache personalizada
COPY apache/vhost.conf /etc/apache2/sites-available/000-default.conf

# Exponemos puerto 80
EXPOSE 80

# Comando para arrancar Apache en primer plano
CMD ["apache2-foreground"]
