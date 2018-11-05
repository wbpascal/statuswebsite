# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Use a kubernetes all-in-one box for the base box
  config.vm.box = "flixtech/kubernetes"

  # Setup additional programs
  config.vm.provision :shell, path: 'config/vagrant/build_dependency_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/git_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/helm_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/docker_registry_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/nfs_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/kafka_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/influxdb_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/postgresql_setup.sh'
  # config.vm.provision :shell, path: 'config/vagrant/icinga_setup.sh'
  config.vm.provision :shell, path: 'config/vagrant/skaffold_setup.sh'
  
  config.vm.network :forwarded_port, host: 3000, guest: 3000
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.network :forwarded_port, host: 8081, guest: 8081
  
  config.vm.provider "virtualbox" do |v|
    v.cpus = 4
    v.memory = 4048
	# Use max 50% of cpu
	v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
	# Needed to enable symlinks in VirtualBox shared folders
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end
end
