#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/helm_setup.sh'"

# Install Helm if not available
if [ -z `which helm` ]; then
  echo "===== Installing Helm"
  curl -LSs https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
  chmod 700 get_helm.sh
  ./get_helm.sh
  
  echo "===== Installing Helm Tiller to Kubernetes cluster"
  kubectl create serviceaccount -n kube-system tiller
  kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller
  helm init --service-account tiller --wait
  
  echo "===== Adding Helm incubator to cluster"
  helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/helm_setup.sh'"
