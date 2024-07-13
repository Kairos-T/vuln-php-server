FROM php:8.0-apache

COPY . /var/www/html

RUN chmod -R 777 /var/www/html/uploads

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 8080

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    a2ensite 000-default && \
    service apache2 restart 

CMD ["apache2-foreground"]
