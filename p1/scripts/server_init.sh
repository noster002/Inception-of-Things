#!/bin/bash

# args = [ ServerIp ]

export INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --node-ip $1"

wget -qO - https://get.k3s.io | sh

# token in synced folder can be used by workers to connect
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token
