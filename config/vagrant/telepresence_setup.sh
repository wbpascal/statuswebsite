#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/telepresence_setup.sh'"

# Install Telepresence if not available
if [ -z `which telepresence` ]; then
  echo "===== Installing Telepresence"
  curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | sudo bash
  sudo apt install -y --no-install-recommends telepresence
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/telepresence_setup.sh'"
