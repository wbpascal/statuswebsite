#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/influxdb_setup.sh'"

echo "===== Adding InfluxDB to cluster"
kubectl create ns influxdb
helm install --name global-influxdb --namespace influxdb stable/influxdb

echo "=== End Vagrant Provisioning using 'config/vagrant/influxdb_setup.sh'"
