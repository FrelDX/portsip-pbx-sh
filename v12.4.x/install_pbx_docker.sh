#!/bin/bash
system_check(){
        if [  -f "/etc/redhat-release" ];then
        Install_docker_on_centos
        elif [ -f "/etc/lsb-release" ];then
        Install_docker_on_ubuntu
        elif [ -f "/etc/debian_version" ];then
        Install_docker_on_debian
        else
           echo "Unknown operating system"
           exit
        fi
}
set_ufw(){
sudo systemctl enable ufw
sudo  systemctl start ufw
sudo ufw allow ssh
sudo ufw allow 25000:34999,45000:64999/udp
sudo ufw allow 8881:8884,8899:8900,8887:8888/tcp
sudo ufw reload
}
Install_docker_on_centos(){
 sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
 yum install -y yum-utils device-mapper-persistent-data lvm2
 yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 yum install -y docker-ce docker-ce-cli containerd.io
 systemctl enable docker
 systemctl start docker
 systemctl enable firewalld
 systemctl start firewalld
 firewall-cmd --permanent --new-service=portsip-pbx
 firewall-cmd --permanent --service=portsip-pbx --add-port=45000-64999/udp --add-port=25000-34999/udp --add-port=8881-8884/tcp --add-port=8899-8900/tcp --add-port=8887-8888/tcp --set-description="PortSIP PBX"
 firewall-cmd --permanent --add-service=portsip-pbx
 firewall-cmd --reload

}
Install_docker_on_ubuntu(){
sudo apt-get remove -y  docker docker-engine docker.io containerd runc
sudo apt update -y
sudo apt upgrade -y 
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y 
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
set_ufw

}
Install_docker_on_debian(){
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt update -y 
sudo apt upgrade -y 
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y 
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo  apt-get update -y 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
set_ufw
}


system_check
