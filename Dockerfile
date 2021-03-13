# Dockerfile to build an Nginx image Based on Ubuntu's latest version
#FROM php:8.0.3-apache-buster
FROM php:7.2.30-apache-buster

LABEL maintainer Anto Online anto@anto.online

# Setup OS
RUN apt-get update

RUN apt-get install -y wget unzip nano cron libzip-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev
#RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-configure gd

RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install bcmath

RUN docker-php-ext-install zip

# Configure Apache 
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Setup Container
RUN mkdir /app
RUN cd /app
WORKDIR /app

#COPY invoice-ninja-5-1-14.zip /app
RUN curl -O -J 'https://5e2ca0fa982f458bbf0517bec5e65c39.s3-ap-southeast-2.amazonaws.com/InvoiceNinjaDockerBuildFiles/invoice-ninja-4.5.34.zip'
#COPY invoice-ninja-4.5.34.zip /app

COPY entrypoint.sh /app

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]

# Setting the default port 
EXPOSE 80
