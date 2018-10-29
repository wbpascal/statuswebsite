#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/build_dependency_setup.sh'"

# Install build dependencies for a sane build environment
apt-get -y update
apt-get -y install apt-transport-https ca-certificates curl make socat software-properties-common

echo "=== End Vagrant Provisioning using 'config/vagrant/build_dependency_setup.sh'"
