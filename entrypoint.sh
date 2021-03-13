#!/bin/bash

# Check if Invoice Ninja is already setup

if [ ! -f "/var/www/artisan" ]; then
    echo "Invoice Ninja is not setup. Doing it now."

    # Unzip and set Invoice Ninja permissions
    #unzip /app/invoice-ninja-5-1-14.zip -d /var/www/
    unzip /app/invoice-ninja-4.5.34.zip -d /var/www/

    # Tidy up folders - zip folder diff betweeb 4.5 and 5.1
    if [ -d "/var/www/ninja/" ]; then
      mv /var/www/ninja/* /var/www/
      rm -rf /var/www/ninja/
    fi

    # Set permissions
    chown www-data:www-data /var/www/ -R
    chmod 755 /var/www/storage/ -R

    # Add Invoice Ninja Virtual Host
    echo "<VirtualHost *:80>
        DocumentRoot /var/www/public
        <Directory /var/www/public>
           DirectoryIndex index.php
           Options +FollowSymLinks
           AllowOverride All
           Require all granted
        </Directory>
        ErrorLog /var/log/invoice-ninja.error.log
        CustomLog /var/log/invoice-ninja.access.log combined
    </VirtualHost>" >> /etc/apache2/sites-available/invoice-ninja.conf

    # Send logs to stdout/stderr
    ln -sf /dev/stdout /var/log/invoice-ninja.access.log
    ln -sf /dev/stderr /var/log/invoice-ninja.error.log

    # Adjust Apache config and restart
    a2dissite 000-default.conf
    a2ensite invoice-ninja.conf
    a2enmod rewrite

    # Configure Cron
    echo "$(echo '0 8 * * * /usr/local/bin/php /var/www/artisan ninja:send-invoices > /dev/null' ; crontab -l)" | crontab -
    echo "$(echo '0 8 * * * /usr/local/bin/php /var/www/artisan ninja:send-reminders > /dev/null' ; crontab -l)" | crontab -

    # Reload apache
    echo "Done installing! "
    service apache2 reload
fi

echo "Invoice Ninja is setup and ready to go!"

# Tidy up folders
if [ -d "/var/www/html/" ]; then
  rm -rf /var/www/html/
fi

# Ready to go!
apache2-foreground
