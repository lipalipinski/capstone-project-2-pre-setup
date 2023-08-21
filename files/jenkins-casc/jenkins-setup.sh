#!/bin/bash

# this script installs plugins, jenkins-casc.yaml and restarts jenkins.service

# jenkins plugin manager
java -jar "./jenkins-plugin-manager-2.12.13.jar" \
  --war /usr/share/java/jenkins.war \
  --plugin-download-directory "$JENKINS_HOME/plugins" \
  --plugin-file "./jenkins-plugins.yaml"
chown -R jenkins:jenkins $JENKINS_HOME/plugins/

# jenkins casc yaml
cp ./jenkins-casc.yaml $JENKINS_HOME/jenkins.yaml
chown jenkins:jenkins $JENKINS_HOME/jenkins.yaml

# restart jenkins service
systemctl restart jenkins