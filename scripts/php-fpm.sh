#!/bin/bash

echo "================================================================================"
echo " Installing PHP "
echo "================================================================================"

sudo apt-get install -y php5-fpm php5-curl php5-json php5-cgi php5-cli php5-redis \
php5-common php5-mcrypt php5-memcached php5-sqlite php5-oauth php5-imagick \
php5-imap php5-dev php-pear php5-mysqlnd php5-apcu php5-gd php5-gmp php5-xdebug

echo "================================================================================"
echo " Configuring PHP-FPM "
echo "================================================================================"

sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

echo "================================================================================"
echo " Configuring Mcrypt "
echo "================================================================================"

ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
php5enmod mcrypt

echo "================================================================================"
echo " Restarting PHP "
echo "================================================================================"
service php5 restart
