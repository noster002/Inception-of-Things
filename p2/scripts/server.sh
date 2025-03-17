#!/bin/bash

# args = [ ServerIp ]

export INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --node-ip $1"

wget -qO - https://get.k3s.io | sh
