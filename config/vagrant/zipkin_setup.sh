#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/zipkin_setup.sh'"

echo "=== Applying zipkin yml to cluster"
kubectl apply -f /vagrant/config/zipkin/zipkin.yaml

echo "=== End Vagrant Provisioning using 'config/vagrant/zipkin_setup.sh'"
