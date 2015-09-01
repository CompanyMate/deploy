#!/bin/bash

echo "================================================================================"
echo " Getting Info "
echo "================================================================================"

read -e -p "Enter your Domain Name: " DOMAIN
read -e -p "Enter your Application Name: " APPNAME
read -e -p "Enter your Username: " NAME
read -e -p "Enter your Password: " PASSWORD
read -e -p "Enter your SSH Key: " SSH

echo "================================================================================"
echo " Downloading Scripts "
echo "================================================================================"

sudo mkdir /scripts && cd /scripts

sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/bower.sh > bower.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/composer.sh > composer.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/envoy.sh > envoy.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/git.sh > git.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/grunt.sh > grunt.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/gulp.sh > gulp.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/haraka.sh > haraka.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/laravel.sh > laravel.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/lumen.sh > lumen.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/mysql.sh > mysql.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/nginx.sh > nginx.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/nodejs.sh > nodejs.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/php-fpm.sh > php-fpm.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/redis.sh > redis.sh
sudo curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/security.sh > security.sh

echo "================================================================================"
echo " Updating Server "
echo "================================================================================"

sudo apt-get update
sudo apt-get upgrade -y

echo "================================================================================"
echo " Installing Dependencies "
echo "================================================================================"

sudo apt-get install -y build-essential libssl-dev wget memcached

echo "================================================================================"
echo " Configuring Timezone "
echo "================================================================================"

sudo -ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
sudo apt-get install -y ntp

echo "================================================================================"
echo " Creating Swapfile "
echo "================================================================================"

fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile      none      swap      sw      0      0" >> /etc/fstab
echo "vm.swapiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf

echo "================================================================================"
echo " Securing Server "
echo "================================================================================"

sudo bash /scripts/security.sh

echo "================================================================================"
echo " Installing PHP-FPM "
echo "================================================================================"

sudo bash /scripts/php-fpm.sh

echo "================================================================================"
echo " Installing Nginx "
echo "================================================================================"

sudo bash /scripts/nginx.sh

echo "================================================================================"
echo " Installing MySQL "
echo "================================================================================"

sudo bash /scripts/mysql.sh

echo "================================================================================"
echo " Installing Redis "
echo "================================================================================"

sudo bash /scripts/redis.sh

echo "================================================================================"
echo " Installing Git "
echo "================================================================================"

sudo bash /scripts/git.sh

echo "================================================================================"
echo " Installing Composer "
echo "================================================================================"



echo "================================================================================"
echo " Installing Laravel "
echo "================================================================================"



echo "================================================================================"
echo " Installing Lumen "
echo "================================================================================"



echo "================================================================================"
echo " Installing Envoy "
echo "================================================================================"



echo "================================================================================"
echo " Installing Node.JS and NPM "
echo "================================================================================"



echo "================================================================================"
echo " Installing Bower "
echo "================================================================================"



echo "================================================================================"
echo " Installing Grunt "
echo "================================================================================"



echo "================================================================================"
echo " Installing Gulp "
echo "================================================================================"



echo "================================================================================"
echo " Installing Haraka "
echo "================================================================================"



echo "================================================================================"
echo " Setup Complete! "
echo "================================================================================"
