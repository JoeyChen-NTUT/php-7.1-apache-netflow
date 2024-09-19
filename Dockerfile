FROM php:7.1-apache

RUN curl -o /usr/local/share/ca-certificates/NTUT_CA.crt https://raw.githubusercontent.com/JoeyChen-NTUT/php-7.3-apache/master/NTUT_Computer_And_Network_Center_Root_CA.crt
RUN update-ca-certificates --fresh

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt clean
RUN apt update
RUN apt install -y apt-utils git libxml2-dev inetutils-ping
RUN docker-php-ext-install soap
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#modify php.ini for env require
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 256M/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/post_max_size = 8M/post_max_size = 256M/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/memory_limit = 128M/memory_limit = 1024M/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/max_file_uploads = 20/max_file_uploads = 300/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/max_input_time = 60/max_input_time = 120/g' /usr/local/etc/php/php.ini

#enable mods
RUN a2enmod rewrite
