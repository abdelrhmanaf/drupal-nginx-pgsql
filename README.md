# Drupal Installation Guide

This guide outlines the steps to install Drupal 10.2.5 on a Debian-based system using Nginx, PHP-FPM, and PostgreSQL.

## Installation Steps

1. Update package lists and install required packages:

    ```bash
    sudo apt update
    sudo apt install -y nginx php-fpm php-pgsql postgresql postgresql-contrib unzip -y
    sudo apt install php-gd php-dom php-xml php-mbstring -y
    ```

2. Create a PostgreSQL user and database for Drupal:

    ```bash
    sudo -i -u postgres
    createuser -P drupaluser
    createdb -O drupaluser drupaldb
    exit
    ```

3. Download and extract Drupal:

    ```bash
    sudo wget https://ftp.drupal.org/files/projects/drupal-10.2.5.zip
    unzip drupal-10.2.5
    sudo mv drupal-10.2.5/* /var/www/html/
    ```

4. Configure Nginx for Drupal:

    ```bash
    sudo echo "server {
        listen 80;
        server_name your_public_ip;

        root /var/www/html;
        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php8.2-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

        location ~ /\.ht {
            deny all;
        }
    }" >> /etc/nginx/sites-available/drupal

    sudo ln -s /etc/nginx/sites-available/drupal /etc/nginx/sites-enabled/
    sudo rm /etc/nginx/sites-enabled/default
    ```

5. Set up Drupal directories and permissions:

    ```bash
    mkdir -p /var/www/html/sites/default/files
    sudo chown -R www-data:www-data /var/www/html/sites/default/files
    sudo chmod -R 755 /var/www/html/sites/default/files
    sudo cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php
    sudo chown www-data:www-data /var/www/html/sites/default/settings.php
    sudo chmod 644 /var/www/html/sites/default/settings.php
    ```

6. Configure PHP:

    ```bash
    sudo ln -s /etc/php/8.2/mods-available/mbstring.ini /etc/php/8.2/cli/conf.d/20-mbstring.ini
    ```

7. Restart Nginx and PHP-FPM:

    ```bash
    sudo nginx -t
    sudo systemctl restart nginx
    sudo systemctl restart php8.2-fpm.service
    ```

8. Check for errors:

    ```bash
    tail /var/log/nginx/error.log
    ```

9. (Optional) Adjust PHP-FPM settings:

    ```bash
    vim /etc/php/8.2/fpm/pool.d/www.conf
    ```

10. Verify PHP-FPM socket:

    ```bash
    ls -la /run/php/php8.2-fpm.sock
    ```

## Conclusion

You have now installed Drupal 10.2.5 on your Debian-based system. You can access the Drupal site via your server's IP address.
