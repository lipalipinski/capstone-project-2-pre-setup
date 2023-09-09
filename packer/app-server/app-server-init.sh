#!/bin/bash 

export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive

AWS_CLI_VER="2.13.9"
DOCKER_VERSION_STRING="5:24.0.5-1~ubuntu.22.04~jammy"

####
echo "Dissable interactive restart prompt"
sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' \
  /etc/needrestart/needrestart.conf

####
echo "apt update & upgrade"
apt-get update -y && apt-get upgrade -y

echo "Install packages..."
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  glibc-source \
  gnupg \
  groff \
  jq \
  less \
  software-properties-common \
  wget \
  unzip \

python3 -m pip install \
  boto3

####
echo "install AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWS_CLI_VER.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

####
echo "uninstall any old docker"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; 
  do sudo apt-get remove $pkg; 
done;

####
echo "install docker"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg 

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y

sudo apt-get install -y \
  docker-ce=$DOCKER_VERSION_STRING \
  docker-ce-cli=$DOCKER_VERSION_STRING \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

  groupadd docker
  usermod -aG docker ubuntu

echo "All done!"