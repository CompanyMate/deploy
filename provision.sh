#!/bin/bash

read -e -p "Enter your username: " NAME
read -e -p "Enter your SSH Key: " SSH

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
usermod -a -G www-data $USER

# Install Dependencies
apt-get install -y build-essential libssl-dev nano wget curl

# Configure Timezone
-ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
apt-get install ntp

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
ufw enable

# Configure SSH
sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh restart

# Install and Configure Nginx
apt-get install nginx
sed -i "s/user www-data;/user $USER;/" /etc/nginx.nginx.conf
service nginx restart
