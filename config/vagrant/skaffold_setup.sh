#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/skaffold_setup.sh'"

# Install Skaffold if not available
if [ -z `which skaffold` ]; then
  echo "===== Installing Skaffold"
  curl -LsSo skaffold storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 
  chmod +x skaffold 
  sudo mv skaffold /usr/local/bin
  
  # Correct kubeconfig path
  echo "export KUBECONFIG=/etc/kubeconfig.yml" >> /home/vagrant/.profile
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/skaffold_setup.sh'"
