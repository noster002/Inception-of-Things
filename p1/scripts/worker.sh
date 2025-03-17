#!/bin/bash

# args = [ ServerIp, ServerWorkerIp ]

export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token $(cat /vagrant/token) --node-ip $2"

wget -qO - https://get.k3s.io | sh

rm /vagrant/token
