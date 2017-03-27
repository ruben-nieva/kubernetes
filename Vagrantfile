# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  #config.vm.box = "ubuntu/trusty64"

  # config.vm.synced_folder "../data", "/vagrant_data"

## Setup for Kubernetes Master
        config.vm.define "master" do |master|
                master.vm.hostname = "kube-master"
                #master.vm.box = "ubuntu/trusty64"
                master.vm.box = "bento/centos-7.1"
                master.ssh.insert_key = false
                master.vm.provider "virtualbox" do |vb|
                 vb.memory = "1024"
                 vb.cpus = "2"
                end
                #master.vm.network "private_network", type: "dhcp"
                master.vm.network "private_network", ip: "172.31.32.10"
                master.vm.provision "shell", path: "scripts/provision-master.sh"
        end

# Setup for Kubernetes Minions
         (1..2).each do |i|
           config.vm.define "minion-0#{i}" do |minion|
             minion.vm.box = "bento/centos-7.1"
             minion.ssh.insert_key = false
             minion.vm.provider "virtualbox" do |vb|
              vb.memory = "1024"
              vb.cpus = "1"
             end
             minion.vm.hostname = "minion-0#{i}"
             minion.vm.network "private_network", ip: "172.31.32." + (20 + i.to_i).to_s
             minion.vm.provision "shell", path: "scripts/provision-minion.sh"
           end
         end

end
