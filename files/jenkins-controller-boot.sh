#!/bin/bash

JENKINS_VER="=2.414.*"
SETUP_REPO_DIR="/root/pre-setup"

apt-get update -y && apt-get upgrade -y

# clone pre-setup repo
git clone https://github.com/lipalipinski/capstone-project-2-pre-setup.git $SETUP_REPO_DIR

# get jenkins worker ssh private key
aws secretsmanager get-secret-value \
  --output text \
  --query "SecretString" \
  --secret-id $JENKINS_WORKER_PK_NAME > /root/.ssh/$JENKINS_WORKER_PK_NAME && \
# python3 $SETUP_REPO_DIR/files/get_secret.py $JENKINS_WORKER_PK_NAME && \
  cp /root/.ssh/$JENKINS_WORKER_PK_NAME /home/ubuntu/.ssh/ && \
  chown ubuntu:ubuntu /home/ubuntu/.ssh/$JENKINS_WORKER_PK_NAME 

# install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins$JENKINS_VER

# jenkins setup ( serving port and user and home dir)
mkdir $JENKINS_HOME
cp -R /var/lib/jenkins/* $JENKINS_HOME/
chown -R jenkins:jenkins $JENKINS_HOME
sed -i "/JENKINS_HOME/c JENKINS_HOME=$JENKINS_HOME" /etc/default/jenkins
mkdir /etc/systemd/system/jenkins.service.d/ 
cat << EOF > /etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="JENKINS_HOME=$JENKINS_HOME"
Environment="JENKINS_PORT=80"
AmbientCapabilities=CAP_NET_BIND_SERVICE
EOF
systemctl daemon-reload

# install jenkins plugins and run jenkins casc
$SETUP_REPO_DIR/files/jenkins-casc/jenkins-setup.sh
