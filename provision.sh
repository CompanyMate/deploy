#!/bin/bash

read -e -p "Enter your Domain Name: " DOMAIN
read -e -p "Enter your Application Name: " APPNAME
read -e -p "Enter your Username: " NAME
read -e -p "Enter your Password: " PASSWORD
read -e -p "Enter your SSH Key: " SSH

# Update Server
apt-get update
apt-get upgrade -y

# Install Dependencies
apt-get install -y build-essential libssl-dev wget memcached

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
ufw -y enable

# Configure SSH
sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh restart

# Create User
sudo su -c "useradd $NAME -s /bin/bash -m -g sudo"
mkdir -p /home/$NAME/.ssh
su $NAME <<'EOF'
chmod 700 /home/$NAME/.ssh
EOF
echo $SSH >> /home/$NAME/.ssh/authorized_keys
echo "$NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure Fail2Ban
apt-get install -y fail2ban

# Run Installation as New User
sudo su $NAME <<'EOS'
cd ~/

# Install and Configure Nginx
sudo apt-get install -y nginx
sudo mkdir -p /var/www/html/$APPNAME/current/public
sudo cat <<EOF > /var/www/html/$APPNAME/current/public/index.php
<?php echo ucase($APPNAME); ?>
EOF
sudo cat <<EOF > /etc/nginx/sites-available/default
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
sudo service nginx restart

# Install and Configure PHP-FPM
sudo apt-get install -y php5-fpm php5-curl php5-json php5-cgi php5-cli php5-redis php5-common php5-mcrypt \
  php5-memcached php5-sqlite php5-oauth php5-imagick php5-imap php5-dev php-pear php5-mysqlnd php5-apcu \
  php5-gd php5-gmp php5-xdebug
sudo sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
sudo ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
sudo php5enmod mcrypt
sudo service nginx restart
sudo service php5 restart

# Install and Configure Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo printf "\nPATH=\"/home/$NAME/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/$NAME/.profile
sudo echo "alias composer='/usr/local/bin/composer'" >> /home/$NAME/.bashrc

# Install and Configure MySQL


# Install and Configure Node.JS and NPM
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs

# Install and Configure Grunt
sudo npm install -g grunt-cli

# Install and Configure Gulp
sudo npm install -g gulp

# Install and Configure Bower
sudo npm install -g bower

# Install and Configure Redis
sudo apt-get install -y redis-server redis-tools

# Install and Configure Git
sudo apt-get install -y git git-core

# Install and Configure Haraka
sudo npm install -g Haraka
# haraka -i /usr/share/mail

# Install and Configure Laravel
sudo composer global require "laravel/installer=~1.1"
sudo echo "alias laravel='/home/$NAME/.composer/vendor/laravel/installer/laravel'" >> /home/$NAME/.bashrc

# Install and Configure Lumen
sudo composer global require "laravel/lumen-installer=~1.0"
sudo echo "alias lumen='/home/$NAME/.composer/vendor/laravel/lumen/lumen'" >> /home/$NAME/.bashrc

# Install and Configure Envoy
sudo /usr/local/bin/composer global require "laravel/envoy=~1.0"
sudo echo "alias envoy='/home/$NAME/.composer/vendor/laravel/envoy/envoy'" >> /home/$NAME/.bashrc

EOS
