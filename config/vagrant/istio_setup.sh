#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/istio_setup.sh'"

# Install Istio if not available
if [ -z `which istioctl` ]; then
  echo "===== Adding Istio to cluster"
  curl -LsS https://github.com/istio/istio/releases/download/1.0.2/istio-1.0.2-linux.tar.gz | tar xz
  cd istio-1.0.2
  helm install install/kubernetes/helm/istio --name istio --namespace istio-system

  echo "===== Istio: Activating automatic sidecar injection"
  kubectl label namespace default istio-injection=enabled

  echo "===== Adding Istio client to path"
  mv bin/istioctl /usr/local/bin/istioctl
fi



echo "=== End Vagrant Provisioning using 'config/vagrant/istio_setup.sh'"
