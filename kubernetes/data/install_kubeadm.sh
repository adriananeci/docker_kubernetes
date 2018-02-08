#!/usr/bin/env bash

# https://kubernetes.io/docs/setup/independent/install-kubeadm/

### INITIAL SETUP ###
yum -y install vim

# remove swap
swapoff $(cat /etc/fstab | grep swap | cut -d ' ' -f1)
sed -e '/swap/ s/^#*/#/' -i /etc/fstab

setenforce 0
sed 's/SELINUX=enforcing/SELINUX=permissive/g' -i /etc/selinux/config


### INSTALL DOCKER ###
yum install -y docker

# Note: Make sure that the cgroup driver used by kubelet is the same as the one used by Docker.
# To ensure compatability you can either update Docker, like so:

#cat << EOF > /etc/docker/daemon.json
#{
#  "exec-opts": ["native.cgroupdriver=systemd"]
#}
#EOF

# Or ensure the --cgroup-driver kubelet flag is set to the same value as Docker (e.g. cgroupfs).




systemctl enable docker && systemctl start docker


### INSTALL KUBEADM, KUBELET, KUBECTL ###
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet


cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

yum -y install go git
go get github.com/kubernetes-incubator/cri-tools/cmd/crictl