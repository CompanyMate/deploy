#!/bin/bash

# read -e -p "Enter your Domain Name: " DOMAIN
# read -e -p "Enter your Application Name: " APPNAME
# read -e -p "Enter your Username: " NAME
# read -e -p "Enter your Password: " PASSWORD
# read -e -p "Enter your SSH Key: " SSH

DOMAIN=$1
APPNAME=$2
NAME=$3
PASSWORD=$4
SSH=$5

# Update Server
apt-get update
apt-get-upgrade -y

# Create Group
addgroup $USER

# Create User
useradd $USER --create-home --shell /bin/bash --groups $USER
mkdir -p /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
cat $SSH >> /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER -R
echo '$USER ALL=(ALL:ALL) ALL' >> /etc/sudoers
usermod -a -G www-data $USER

# Install Dependencies
apt-get install -y build-essential libssl-dev nano wget curl memcached

# Configure Timezone
-ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
apt-get install -y ntp

# Create Swapfile
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile      none      swap      sw      0      0" >> /etc/fstab
echo "vm.swapiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf

# Configure Firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable -y

# Install and Configure Nginx
apt-get install -y nginx
sed -i "s/user www-data;/user $USER;/" /etc/nginx/nginx.conf
mkdir -p /var/www/html
cat <<EOF >> /etc/nginx/sites-available/default
server {
  listen 80 default_server;
  listen [::]:80 default_server ipv6only=on;
  root /var/www/html/$APPNAME/public;
  index index.php index.html index.htm;
  server_name localhost;
  
  location / {
    try_files \$uri \$uri/ =404;
  }
  
  error_page 404 /404.html;
  error_page 500 502 503 504 /50x.html;
  
  location = /50x.html {
    root /var/www/html/$APPNAME/public;
  }
  
  location ~ \\.php\$ {
    try_files \$uri =404;
    fastcgi_split_path_info ^(.+\\.php)(/.+)\$;
    fastcgi_pass unix:/var/run/php5-fpm.sock; 
    fastcgi_index index.php;
    include fastcgi.conf;
  }
}
EOF
service nginx restart

# Install and Configure PHP-FPM
apt-get install -y php5-fpm php5-curl php5-json php5-cgi php5-cli php5-redis php5-common php5-mcrypt \
  php5-memcached php5-sqlite php5-mysql php5-oauth php5-imagick php5-imap php5-dev php-pear \
  php5-mysqlnd php5-apcu php5-gd php5-gmp php5-xdebug
sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
php5enmod mcrypt
service nginx restart
service php5 restart

# Install and Configure Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
printf "\nPATH=\"/home/$USER/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/$USER/.profile

# Install and Configure MySQL


# Install and Configure Node.JS and NPM
curl -sL https://deb.nodesource.com/setup | sudo bash -
apt-get install -y nodejs

# Install and Configure Grunt
sudo npm install -g grunt-cli

# Install and Configure Gulp
sudo npm install -g gulp

# Install and Configure Bower
sudo npm install -g bower

# Install and Configure Redis
apt-get install -y redis-server redis-tools

# Install and Configure Git
apt-get install -y git

# Install and Configure Haraka
sudo npm install -g Haraka
haraka -i /usr/share/mail

# Install and Configure Laravel
composer global require "laravel/installer=~1.1"

# Install and Configure Lumen
composer global require "laravel/lumen-installer=~1.0"

# Install and Configure Envoy
composer global require "laravel/envoy=~1.0"

# Install and Configure Application
cd /var/www/html
laravel new $APPNAME
cd /var/www/html/$APPNAME
npm install

# Configure SSH
sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh restart
