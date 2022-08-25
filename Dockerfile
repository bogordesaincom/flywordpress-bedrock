FROM serversideup/php:7.4-fpm-nginx

# Install PHP Imagemagick using regular Ubuntu commands
RUN apt-get update && apt-get install -y \
    curl zip unzip rsync ca-certificates nano htop cron \ 
    php7.4-xml php7.4-mysql php7.4-mbstring php7.4-bcmath php7.4-dom php7.4-curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
# copy application code, skipping files based on .dockerignore
COPY . /var/www/html
COPY ./web/app/uploads/ /var/www/html/web/app/uploads

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN composer install --optimize-autoloader --no-dev \
    && rm -rf /etc/cont-init.d/* \
    && cp docker/nginx-default /etc/nginx/sites-available/default \
    && cp docker/entrypoint.sh /entrypoint \
    && chown -R webuser:webgroup /var/www/html  \
    && chmod 755 -R /var/www/html/web/app/uploads \
    && chmod +x /entrypoint
    
EXPOSE 8080

ENTRYPOINT ["/entrypoint"]
