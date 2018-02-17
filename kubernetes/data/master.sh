#!/usr/bin/env bash

kubeadm init --apiserver-advertise-address=192.168.100.100 --pod-network-cidr 10.244.0.0/16 > /data/.kubeadmin_init
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f /data/dashboard/dashboard-svc.yaml
kubectl apply -f /data/rbac/rbac.yaml

kubectl describe secret $(kubectl get secrets | grep cluster | cut -d ' ' -f1) | grep token:  | tr -s ' ' | cut -d ' ' -f2 > /data/cluster_admin_token.txt
echo "export KUBECONFIG=/etc/kubernetes/admin.conf"  >> /root/.bashrc
