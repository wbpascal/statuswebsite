#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/postgresql_setup.sh'"

echo "==== Creating persistant volumes for PostgreSQL"
sudo mkdir -p /kubernetes/postgresql
kubectl apply -f /vagrant/config/postgresql/persistant_volumes.yml

echo "===== Adding PostgreSQL to cluster"
helm install --name postgresql --wait --version 1.0.0 \
             --set persistence.enabled=true \
			 --set persistence.storageClass=postgresql \
			 --set persistence.size=1Gi \
			 --set postgresqlPassword=postgres \
			 stable/postgresql

echo "=== End Vagrant Provisioning using 'config/vagrant/postgresql_setup.sh'"