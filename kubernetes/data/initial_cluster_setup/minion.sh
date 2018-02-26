#!/usr/bin/env bash

# configure /etc/hosts file
echo "192.168.100.100   master master.local" >> /etc/hosts
[[ $hostname == "node01.local" ]] && opposite="02" || opposite="01"
echo "192.168.100.1${opposite}   node${opposite} node${opposite}.local" >> /etc/hosts

cluster_join=""

while [ "$cluster_join" == "" ] ; do
    echo "waiting for the master node";
    sleep 1;
    cluster_join="$(cat /data/initial_cluster_setup/.kubeadmin_init  | grep 'kubeadm join')"
done

export PATH=$PATH:/root/go/bin/
$cluster_join --ignore-preflight-errors=cri
