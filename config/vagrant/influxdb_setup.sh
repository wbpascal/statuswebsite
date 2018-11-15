#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/influxdb_setup.sh'"

echo "===== Creating persistant volumes for InfluxDB"
sudo mkdir -p /kubernetes/influxdb
sudo chmod 777 /kubernetes/influxdb
kubectl apply -f /vagrant/config/influxdb/persistant_volumes.yml

echo "===== Adding InfluxDB to cluster"
helm install --name influxdb --wait \
             --set persistence.enabled=true \
			 --set persistence.storageClass=influxdb \
			 --set persistence.size=1Gi \
			 --set setDefaultUser.enabled=true \
			 --set setDefaultUser.user.password=password \
			 stable/influxdb
			
echo "=====	Running last fixes on InfluxDB"	
kubectl exec $(kubectl get pods --namespace default -l app=influxdb-influxdb -o jsonpath='{.items[0].metadata.name}') -- influx -execute 'create database icinga2'
kubectl exec $(kubectl get pods --namespace default -l app=influxdb-influxdb -o jsonpath='{.items[0].metadata.name}') -- influx -execute "create user icinga2 with password 'icinga'"
kubectl exec $(kubectl get pods --namespace default -l app=influxdb-influxdb -o jsonpath='{.items[0].metadata.name}') -- influx -execute 'grant all on icinga2 to icinga2'

echo "=== End Vagrant Provisioning using 'config/vagrant/influxdb_setup.sh'"
