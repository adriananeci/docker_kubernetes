#!/usr/bin/env bash

# configure /etc/hosts file
echo "192.168.100.101   node01 node01.local" >> /etc/hosts
echo "192.168.100.102   node02 node02.local" >> /etc/hosts

export PATH=$PATH:/root/go/bin/
kubeadm init --apiserver-advertise-address=192.168.100.100 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=cri > /data/initial_cluster_setup/.kubeadmin_init

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f /data/initial_cluster_setup/flannel/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f /data/initial_cluster_setup/dashboard/dashboard-svc.yaml
kubectl apply -f /data/initial_cluster_setup/rbac/rbac.yaml


# install nginx-ingress
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/rbac.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/with-rbac.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/default-backend.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/configmap.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/tcp-services-configmap.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/udp-services-configmap.yaml
kubectl apply -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml


kubectl describe secret $(kubectl get secrets | grep cluster | cut -d ' ' -f1) | grep token:  | tr -s ' ' | cut -d ' ' -f2 > /data/initial_cluster_setup/cluster_admin_token.txt
echo "export KUBECONFIG=/etc/kubernetes/admin.conf"  >> /root/.bashrc

ln -s /data/lab /root/lab
ln -s /data/initial_cluster_setup/cluster_admin_token.txt /root/cluster_admin_token.txt