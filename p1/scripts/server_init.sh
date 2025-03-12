#!/bin/bash

sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install curl

ServerIp=$1

curl -sfL https://get.k3s.io | sh -s - server --write-kubeconfig /home/vagrant/.kube/config --node-ip $ServerIp
sudo chown vagrant:vagrant -R /home/vagrant/.kube

TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

echo $TOKEN > /vagrant/token
