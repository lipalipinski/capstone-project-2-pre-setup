#!/bin/bash

# this script installs plugins, jenkins-casc.yaml and restarts jenkins.service

MYDIR="$(dirname "$(readlink -f "$0")")"

# jenkins plugin manager
printf "\nInstalling plugins...\n"
java -jar "$MYDIR/jenkins-plugin-manager-2.12.13.jar" \
  --war /usr/share/java/jenkins.war \
  --plugin-download-directory "$JENKINS_HOME/plugins" \
  --plugin-file "$MYDIR/jenkins-plugins.yaml"
chown -R jenkins:jenkins $JENKINS_HOME/plugins/

# jenkins casc yaml
printf "\nCopy jenkins.yaml CASC...\n"
cp $MYDIR/jenkins-casc.yaml $JENKINS_HOME/jenkins.yaml
chown jenkins:jenkins $JENKINS_HOME/jenkins.yaml

# restart jenkins service
printf "\nRestart jenkins.service...\n"
systemctl restart jenkins
printf "Done!\n"