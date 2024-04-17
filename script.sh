sudo apt update
sudo apt install -y nginx php-fpm php-pgsql postgresql postgresql-contrib unzip -y
sudo apt install php-gd php-dom php-xml php-mbstring -y
sudo -i -u postgres
createuser -P drupaluser
createdb -O drupaluser drupaldb
exit
sudo wget https://ftp.drupal.org/files/projects/drupal-10.2.5.zip
unzip drupal-10.2.5
sudo mv drupal-10.2.5/* /var/www/html/
# sudo vim /etc/nginx/sites-available/drupal
sudo echo " server {
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
} " >> /etc/nginx/sites-available/drupal

sudo ln -s /etc/nginx/sites-available/drupal /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
mkdir -p /var/www/html/sites/default/files
sudo chown -R www-data:www-data /var/www/html/sites/default/files
sudo chmod -R 755 /var/www/html/sites/default/files
sudo cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php
sudo chown www-data:www-data /var/www/html/sites/default/settings.php
sudo chmod 644 /var/www/html/sites/default/settings.php
sudo ln -s /etc/php/8.2/mods-available/mbstring.ini /etc/php/8.2/cli/conf.d/20-mbstring.ini
sudo chown -R www-data:www-data /var/www/html

sudo nginx -t
sudo systemctl restart nginx
sudo systemctl restart php8.2-fpm.service 
tail /var/log/nginx/error.log
vim /etc/php/8.2/fpm/pool.d/www.conf
ls -la /run/php/php8.2-fpm.sock

