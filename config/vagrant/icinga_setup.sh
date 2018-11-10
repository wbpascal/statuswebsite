#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/icinga_setup.sh'"

echo "=== Building icinga image"
docker build -t localhost:5000/icinga2 /vagrant/config/icinga/docker
docker push localhost:5000/icinga2

echo "=== Applying yml to cluster"
kubectl apply -f /vagrant/config/icinga/deployment.yml
kubectl apply -f /vagrant/config/icinga/service.yml

echo "=== End Vagrant Provisioning using 'config/vagrant/icinga_setup.sh'"
