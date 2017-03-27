#!/usr/bin/env bash

echo "Installing Kubernetes in Minion node ........ please wait"


# Install and enable package requirements
yum install -y ntp
systemctl enable ntpd && systemctl start ntpd

# Comment out hostname localhost
sed -e "/$HOSTNAME/s/^#*/#/" -i /etc/hosts

#Add to /etc/hosts
echo "# Host config for Kebernetes Master and Minions" | sudo tee --append /etc/hosts 2> /dev/null
echo "172.31.32.10  kube-master" | sudo tee --append /etc/hosts 2> /dev/null
echo "172.31.32.20  minion-01" | sudo tee --append /etc/hosts 2> /dev/null
echo "172.31.32.21  minion-02" | sudo tee --append /etc/hosts 2> /dev/null


cat << EOF > /etc/yum.repos.d/virt7-docker-common-release.repo
[virt7-docker-common-release]
name=virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0
enabled=0
EOF

# Install kubernetes and docker
yum install -y --enablerepo=virt7-docker-common-release kubernetes etcd docker

# Configure kubernetes client
echo "Configuring Minion to reach master"
sed -ie 's/127.0.0.1/kube-master/' /etc/kubernetes/config
echo "KUBE_ETCD_SERVERS=\"--etcd-servers=http://kube-mater:2379\"" | sudo tee --append /etc/kubernetes/config 2> /dev/null




# Enable services
systemctl enable kube-proxy kubelet docker
systemctl start kube-proxy kubelet docker
systemctl status kube-proxy kubelet docker | grep running


#Commet out a deprecated line
# sed -e '/templatedir/s/^#*/#/' -i /etc/puppet/puppet.conf

# End of script