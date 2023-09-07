#!/bin/bash

export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive

apt-get update -y && apt-get upgrade -y