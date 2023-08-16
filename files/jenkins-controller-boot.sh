#!/bin/bash

AWS_CLI_VER="2.13.9"

apt-get update -y && apt-get upgrade -y

# install AWS CLI 
apt-get install -y unzip glibc-source groff less
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWS_CLI_VER.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install