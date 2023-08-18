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
  python3-pip \
  wget \
  unzip \

python3 -m pip install \
  boto3

# install AWS CLI 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWS_CLI_VER.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# clone pre-setup repo
git clone https://github.com/lipalipinski/capstone-project-2-pre-setup.git /root/pre-setup

# get jenkins worker ssh private key
python3 /root/pre-setup/files/get_secret.py $JENKINS_WORKER_PK_NAME && \
  cp /root/.ssh/$JENKINS_WORKER_PK_NAME /home/ubuntu/.ssh/ && \
  chown ubuntu:ubuntu /home/ubuntu/.ssh/$JENKINS_WORKER_PK_NAME 

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

# install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins

# set jenkins port to 80
mkdir /etc/systemd/system/jenkins.service.d/ 
cat << EOF > /etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="JENKINS_PORT=80"
AmbientCapabilities=CAP_NET_BIND_SERVICE
EOF
systemctl daemon-reload

# jenkins plugin manager
java -jar "/root/pre-setup/files/jenkins-casc/jenkins-plugin-manager-2.12.13.jar" \
  --war /usr/share/java/jenkins.war \
  --plugin-download-directory "/var/lib/jenkins/plugins" \
  --plugin-file "/root/pre-setup/files/jenkins-casc/jenkins-plugins.yaml"
chown -R jenkins:jenkins /var/lib/jenkins/plugins/

# jenkins casc yaml
cp /root/pre-setup/files/jenkins-casc/jenkins-casc.yaml /var/lib/jenkins/jenkins.yaml
chown jenkins:jenkins /var/lib/jenkins/jenkins.yaml

systemctl restart jenkins
