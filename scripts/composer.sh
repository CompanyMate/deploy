#!/bin/bash

echo "================================================================================"
echo " Installing Composer "
echo "================================================================================"

curl -sS https://getcomposer.org/installer | php

echo "================================================================================"
echo " Configuring Composer "
echo "================================================================================"

sudo mv composer.phar /usr/local/bin/composer
sudo echo "alias composer='sudo /usr/local/bin/composer'" >> ~/.bashrc
