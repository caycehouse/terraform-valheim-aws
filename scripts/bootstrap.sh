#!/bin/bash

# Install docker
sudo yum update -y
sudo yum install docker

# Enable and start docker
sudo systemctl --now enable docker

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
