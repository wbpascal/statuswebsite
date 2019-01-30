# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "wpascal/vs-project"
  config.vm.box_version = "1.0.4"
  
  config.vm.network :private_network, ip: "10.10.0.2", auto_config: false
  
  config.vm.provider "virtualbox" do |v|
    v.cpus = 4
    v.memory = 4096
	# Use max 50% of cpu
	v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
	# Needed to enable symlinks in VirtualBox shared folders
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    
    # The following lines are stolen from https://github.com/flix-tech/vagrant-kubernetes
    # Set the vboxnet interface to promiscous mode so that the docker veth
    # interfaces are reachable
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    # Otherwise we get really slow DNS lookup on OSX (Changed DNS inside the machine)
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end
