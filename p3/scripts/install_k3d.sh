#!/bin/bash

runAsRoot() {
	local CMD="$*"

	if [ $EUID -ne 0 ]; then
		CMD="sudo $CMD"
	fi

	$CMD
}

installDeps() {
	runAsRoot apt-get update
	runAsRoot apt-get install gpg wget dpkg lsb-release
}

installDocker() {
	wget -qO - https://download.docker.com/linux/debian/gpg\
	| runAsRoot gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	# verify the fingerprint of the key
	# gpg --no-default-keyring --keyring /usr/share/keyrings/docker-archive-keyring.gpg --fingerprint
	# should have the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
	echo "Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(lsb_release -cs)
Architectures: $(dpkg --print-architecture)
Components: stable
Signed-By: /usr/share/keyrings/docker-archive-keyring.gpg"\
	| runAsRoot tee /etc/apt/sources.list.d/docker.sources
	runAsRoot apt-get update
	runAsRoot apt-get install docker-ce
	runAsRoot usermod -aG docker $USER
}

installKubectl() {
	wget -qO - https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key\
	| runAsRoot gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
	# verify the fingerprint of the key
	# gpg --no-default-keyring --keyring /usr/share/keyrings/kubernetes-archive-keyring.gpg --fingerprint
	# should have the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
	echo "Types: deb
URIs: https://pkgs.k8s.io/core:/stable:/v1.32/deb/
Suites: /
Architectures: $(dpkg --print-architecture)
Signed-By: /usr/share/keyrings/kubernetes-archive-keyring.gpg"\
	| runAsRoot tee /etc/apt/sources.list.d/kubernetes.sources
	runAsRoot apt-get update
	runAsRoot apt-get install kubectl
}

installK3d() {
	wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}

# Execute

installDeps
installDocker
installKubectl
installK3d

# re-login to apply docker group changes
exec su -l $USER
