#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/icinga_setup.sh'"

echo "===== Adding Icinga 2 repository"
wget -O - https://packages.icinga.com/icinga.key | apt-key add -
echo 'deb https://packages.icinga.com/ubuntu icinga-xenial main' >/etc/apt/sources.list.d/icinga.list
apt-get update

echo "===== Installing Icinga 2 Core"
apt-get -y install icinga2
systemctl enable icinga2
systemctl start icinga2

echo "===== Installing monitoring plugins"
apt-get -y install monitoring-plugins

echo "===== Setting up PostgreSQL IDO"
apt-get -y install icinga2-ido-pgsql
kubectl exec postgresql -- postgres psql -c "CREATE ROLE icinga WITH LOGIN PASSWORD 'icinga'"
kubectl exec postgresql -- postgres createdb -O icinga -E UTF8 icinga

echo "===== Setting up Icinga 2 Web"
icinga2 api setup
/etc/icinga2/conf.d/api-users.conf << EOF
object ApiUser "admin" {
  password = "password"
  permissions = [ "*" ]
}
EOF
systemctl restart icinga2
apt-get -y install icingaweb2 libapache2-mod-php icingacli
icingacli setup token create

echo "=== End Vagrant Provisioning using 'config/vagrant/icinga_setup.sh'"
