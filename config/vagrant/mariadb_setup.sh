#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/mariadb_setup.sh'"

echo "==== Creating persistant volumes for MariaDB"
sudo mkdir -p /kubernetes/mariadb
sudo chmod 777 /kubernetes/mariadb
kubectl apply -f /vagrant/config/mariadb/persistant_volumes.yml

echo "===== Adding MariaDB to cluster"
helm install --name mariadb --wait \
             --set replication.enabled=false \
             --set master.persistence.enabled=true \
             --set master.persistence.storageClass=mariadb \
             --set master.persistence.size=1Gi \
             --set slave.persistence.enabled=true \
             --set slave.persistence.storageClass=mariadb \
             --set slave.persistence.size=1Gi \
             --set db.user=maria \
             --set db.password=maria \
             --set rootUser.password=root \
             stable/mariadb

echo "=== End Vagrant Provisioning using 'config/vagrant/mariadb_setup.sh'"
