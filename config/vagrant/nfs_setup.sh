#!/usr/bin/env bash

echo "=== Begin Vagrant Provisioning using 'config/vagrant/nfs_setup.sh'"

echo "===== Setup NFS server"
sudo mkdir -p /kubernetes
sudo chmod 777 -R /kubernetes
sudo apt-get install -y nfs-kernel-server portmap
echo "/kubernetes 0.0.0.0/0.0.0.0(rw,no_root_squash,subtree_check)" >> /etc/exports
exportfs -a
/etc/init.d/nfs-kernel-server reload

echo "===== Adding nfs client to cluster"
kubectl create ns nfs
helm install --name nfs-client --namespace nfs --wait \
     --set nfs.server=127.0.0.1 \
	 --set rbac.create=false \
	 --set storageClass.defaultClass=true \
	 --set nfs.path=/kubernetes \
	 stable/nfs-client-provisioner

echo "=== End Vagrant Provisioning using 'config/vagrant/nfs_setup.sh'"
