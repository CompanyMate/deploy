# deploy
CompanyMate.com Deploy Script(s)

## Provision
- Run the following command:
```
curl -s https://raw.githubusercontent.com/CompanyMate/deploy/master/provision.sh | sudo bash /dev/stdin domain appname name password ssh
```
- Answer questions
- Enjoy

## Provision does the following:
- [x] Creates a new user and group
- [x] Gives new user sudo rights
- [x] Disables root login
- [x] Installs Memcached
- [x] Installs NTP and configures Timezone
- [x] Creates a 4GB Swapfile
- [x] Configures Firewall (UFW)
- [x] Installs Nginx
- [x] Installs PHP-FPM
- [x] Installs Mcrypt
- [ ] Installs MySQL
- [x] Installs Composer
- [x] Installs Node.JS
- [x] Installs NPM
- [x] Installs Bower
- [x] Installs Grunt
- [x] Installs Gulp
- [x] Installs Redis
- [x] Installs Git
- [x] Installs Laravel
- [x] Installs Lumen
- [x] Installs Envoy
- [x] Installs Elixer
- [x] Installs Application
