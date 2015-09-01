#!/bin/bash

echo "================================================================================"
echo " Downloading Scripts "
echo "================================================================================"

mkdir scripts &&& cd scripts

curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/bower.sh > bower.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/composer.sh > composer.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/envoy.sh > envoy.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/git.sh > git.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/grunt.sh > grunt.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/gulp.sh > gulp.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/haraka.sh > haraka.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/laravel.sh > laravel.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/lumen.sh > lumen.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/mysql.sh > mysql.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/nginx.sh > nginx.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/nodejs.sh > nodejs.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/php-fpm.sh > php-fpm.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/redis.sh > redis.sh
curl https://raw.githubusercontent.com/CompanyMate/deploy/master/scripts/security.sh > security.sh

echo "================================================================================"
echo " Securing Server "
echo "================================================================================"

sudo bash security.sh

echo "================================================================================"
echo " Installing Nginx "
echo "================================================================================"

sudo bash nginx.sh

echo "================================================================================"
echo " Installing PHP-FPM "
echo "================================================================================"

sudo bash php-fpm.sh

echo "================================================================================"
echo " Installing MySQL "
echo "================================================================================"

sudo bash mysql.sh

echo "================================================================================"
echo " Installing Redis "
echo "================================================================================"

sudo bash redis.sh

echo "================================================================================"
echo " Installing Git "
echo "================================================================================"

sudo bash git.sh

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


