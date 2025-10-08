#!/bin/bash
# Install Docker
apt-get update
apt-get install -y docker.io

# Enable Docker service
systemctl enable docker
systemctl start docker

