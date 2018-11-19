#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/forge_setup.sh'"

# Install Forge if not available
if [ -z `which forge` ]; then
	echo "===== Installing Forge"
	curl https://s3.amazonaws.com/datawire-static-files/forge/$(curl https://s3.amazonaws.com/datawire-static-files/forge/latest.url)/forge -o /tmp/forge
	chmod a+x /tmp/forge
	sudo mv /tmp/forge /usr/local/bin
  
	cat >/forge.yaml <<-EOL
	registry:
		type: local
	EOL
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/forge_setup.sh'"
