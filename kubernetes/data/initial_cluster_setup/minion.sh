#!/usr/bin/env bash


cluster_join=""

while [ "$cluster_join" == "" ] ; do
    echo "waiting for the master node";
    sleep 1;
    cluster_join="$(cat /data/initial_cluster_setup/.kubeadmin_init  | grep 'kubeadm join')"
done

$cluster_join
