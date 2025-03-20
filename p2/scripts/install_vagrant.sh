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

installVirtualBox() {
	wget -qO - https://www.virtualbox.org/download/oracle_vbox_2016.asc\
	| runAsRoot gpg --dearmor -o /usr/share/keyrings/oracle-virtualbox-2016.gpg
	# verify the fingerprint of the key (https://www.virtualbox.org/wiki/Linux_Downloads)
	# gpg --no-default-keyring --keyring /usr/share/keyrings/oracle-virtualbox-2016.gpg --fingerprint
	# should have the fingerprint B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF
	echo "Types: deb
URIs: https://download.virtualbox.org/virtualbox/debian
Suites: $(lsb_release -cs)
Architectures: $(dpkg --print-architecture)
Components: contrib
Signed-By: /usr/share/keyrings/oracle-virtualbox-2016.gpg"\
	| runAsRoot tee /etc/apt/sources.list.d/virtualbox.sources
	runAsRoot apt-get update
	runAsRoot apt-get install virtualbox-7.1
}

installVagrant() {
	wget -qO - https://apt.releases.hashicorp.com/gpg\
	| runAsRoot gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
	# verify the fingerprint of the key (https://www.hashicorp.com/security under "Linux Package Checksum Verification")
	# gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
	# should have the fingerprint 798A EC65 4E5C 1542 8C8E  42EE AA16 FCBC A621 E701
	echo "Types: deb
URIs: https://apt.releases.hashicorp.com
Suites: $(lsb_release -cs)
Architectures: $(dpkg --print-architecture)
Components: main
Signed-By: /usr/share/keyrings/hashicorp-archive-keyring.gpg"\
	| runAsRoot tee /etc/apt/sources.list.d/hashicorp.sources
	runAsRoot apt-get update
	runAsRoot apt-get install vagrant
}

# Execution

installDeps
installVirtualBox
installVagrant
