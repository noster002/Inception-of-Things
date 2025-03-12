#!/bin/bash

sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install curl

ServerIp=$1
ServerWorkerIp=$2

TOKEN=$(cat /vagrant/token)

curl -sfL https://get.k3s.io | K3S_URL=https://$ServerIp:6443 sh -s - agent --token $TOKEN --node-ip $ServerWorkerIp
