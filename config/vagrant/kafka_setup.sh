#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/kafka_setup.sh'"

echo "==== Creating persistant volumes for Kafka"
sudo mkdir -p /kubernetes/kafka/broker0
sudo mkdir -p /kubernetes/kafka/broker1
sudo mkdir -p /kubernetes/kafka/broker2
kubectl apply -f /vagrant/config/kafka/kafka_pv.yml

echo "===== Adding Kafka to cluster"
kubectl create ns kafka
helm install --name global-kafka --namespace kafka --set persistence.storageClass=kafka --set persistence.size=1Gi incubator/kafka

echo "=== End Vagrant Provisioning using 'config/vagrant/kafka_setup.sh'"