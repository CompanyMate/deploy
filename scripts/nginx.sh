#!/bin/bash

echo "================================================================================"
echo " Installing Nginx "
echo "================================================================================"

apt-get install -y nginx

echo "================================================================================"
echo " Building Test Page "
echo "================================================================================"

mkdir -p /var/www/html/$APPNAME/current/public

cat <<EOF > /var/www/html/$APPNAME/current/public/index.php
<?php echo ucase($APPNAME); ?>
EOF

echo "================================================================================"
echo " Configuring Nginx "
echo "================================================================================"

cat <<EOF > /etc/nginx/sites-available/default
server {
  listen 80 default_server;
  listen [::]:80 default_server ipv6only=on;
  root /var/www/html/$APPNAME/current/public;
  index index.php index.html index.htm;
  server_name localhost;
  
  location / {
    try_files \$uri \$uri/ =404;
  }
  
  error_page 404 /404.html;
  error_page 500 502 503 504 /50x.html;
  
  location = /50x.html {
    root /var/www/html/$APPNAME/current/public;
  }
  
  location ~ \\.php\$ {
    try_files \$uri =404;
    fastcgi_split_path_info ^(.+\\.php)(/.+)\$;
    fastcgi_pass unix:/var/run/php5-fpm.sock; 
    fastcgi_index index.php;
    include fastcgi_params;
  }
}
EOF

echo "================================================================================"
echo " Restarting Nginx "
echo "================================================================================"

service nginx restart
