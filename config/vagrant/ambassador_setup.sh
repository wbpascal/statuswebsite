#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/ambassador_setup.sh'"

echo "===== Addinga Datawire helm repository"
helm repo add datawire https://www.getambassador.io

echo "===== Adding Ambassador to cluster"
helm install --name ambassador --wait --timeout 1500 \
			 --set rbac.create=false \
			 --set service.type=NodePort \
			 --set service.nodePort=30088 \
			 datawire/ambassador
			 
echo "=== End Vagrant Provisioning using 'config/vagrant/ambassador_setup.sh'"
