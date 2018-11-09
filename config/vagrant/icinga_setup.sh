#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/icinga_setup.sh'"

kubectl apply -f /vagrant/config/icinga/deployment.yml

echo "=== End Vagrant Provisioning using 'config/vagrant/icinga_setup.sh'"
