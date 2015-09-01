#!/bin/bash

echo "================================================================================"
echo " Configuring Firewall "
echo "================================================================================"

ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

echo "================================================================================"
echo " Configuring SSH "
echo "================================================================================"

sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh restart

echo "================================================================================"
echo " Creating New User "
echo "================================================================================"

sudo su -c "useradd $NAME -s /bin/bash -m -g sudo"
mkdir -p /home/$NAME/.ssh
su $NAME <<'EOF'
chmod 700 /home/$NAME/.ssh
EOF
echo $SSH >> /home/$NAME/.ssh/authorized_keys
echo "$NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "================================================================================"
echo " Installing Fail2Ban "
echo "================================================================================"

apt-get install -y fail2ban
