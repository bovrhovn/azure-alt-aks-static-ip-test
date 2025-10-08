#!/bin/bash
set -e
ADMIN_USERNAME=$1
# Update packages
apt-get update

# Install prerequisites
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker repository
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker CE
apt-get update
apt-get install -y docker-ce

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Add admin user to docker group
usermod -aG docker ${ADMIN_USERNAME}

# Verify installation
docker --version