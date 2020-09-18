#!/bin/bash

# Add certbot repository
# add-apt-repository ppa:certbot/certbot -y

# Update package lists
apt-get update

# Upgrade existing packages
apt-get upgrade -y

# Install dependencies to support the addition of a new package repo (docker) that is using HTTPS connectivity:
apt-get install apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker’s official apt repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Download the Docker Compose binaries
curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Add execute permissions to the downloaded binaries
chmod +x /usr/local/bin/docker-compose

# Test installation
docker-compose --version

# ---------------------------------------------------------------------------
# Install NVIDIA driver
# ---------------------------------------------------------------------------
# Install hwinfo so we can determine the the server has a GPU
apt install hwinfo -y

if hwinfo --gfxcard --short | grep -q NVIDIA
then
        echo "Install the driver"
        apt install nvidia-driver-390 -y

        echo "Install the NVIDIA Docker container"
        # Set the GPG and remote repo for the package
        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -

        # Get the distribution
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        echo $distribution
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

        # Update the apt lists
        apt-get update

        # Install the docker container 
        apt-get install -y nvidia-docker2
        pkill -SIGHUP dockerd

        # Test the container
        # docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi

        echo "Reboot the server so the driver thats effect"
        reboot
else
        echo "Server does not support NVIDIA GPU"   
fi




