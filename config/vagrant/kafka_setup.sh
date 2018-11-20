#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/kafka_setup.sh'"

echo "==== Creating persistant volumes for Kafka"
sudo mkdir -p /kubernetes/kafka/broker0
# sudo mkdir -p /kubernetes/kafka/broker1
# sudo mkdir -p /kubernetes/kafka/broker2
sudo chmod 777 -R /kubernetes/kafka
kubectl apply -f /vagrant/config/kafka/persistant_volumes.yml

echo "===== Adding Kafka to cluster"
helm install --name kafka \
             --set persistence.size=1Gi \
             --set persistence.storageClass=kafka \
			 --set replicas=1 \
			 incubator/kafka

echo "=== End Vagrant Provisioning using 'config/vagrant/kafka_setup.sh'"
