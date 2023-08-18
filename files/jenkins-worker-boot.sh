#!/bin/bash

AWS_CLI_VER="2.13.9"

sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' \
  /etc/needrestart/needrestart.conf
apt-get update -y && apt-get upgrade -y

apt-get install -y \
  apt-transport-https \
  glibc-source \
  groff \
  less \
  wget \
  unzip \

# install AWS CLI 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWS_CLI_VER.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# install JDK 17
mkdir -p /etc/apt/keyrings
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee \
  /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] \
  https://packages.adoptium.net/artifactory/deb \
  $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee \
  /etc/apt/sources.list.d/adoptium.list
apt-get update -y 
apt-get install -y temurin-17-jdk