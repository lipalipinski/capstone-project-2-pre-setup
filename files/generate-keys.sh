#!/bin/bash

# Generates ssh keys in specified dir

DEST_DIR="$1"

ssh-keygen -t rsa -m PEM -b 2048 -f "$DEST_DIR/app-server-kp" -N ""
ssh-keygen -t rsa -m PEM -b 2048 -f "$DEST_DIR/jenkins-worker-kp" -N ""