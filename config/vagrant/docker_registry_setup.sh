#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/docker_registry_setup.sh'"

echo "===== Creating private docker registry"
docker run -d -p 5000:5000 --restart=always --name registry registry:2

echo "=== End Vagrant Provisioning using 'config/vagrant/docker_registry_setup.sh'"
