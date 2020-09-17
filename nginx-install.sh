#!/bin/bash

# Add certbot repository
add-apt-repository ppa:certbot/certbot -y

# Update package lists
apt-get update

# Upgrade existing packages
apt-get upgrade -y

# Install nginx
apt-get install nginx -y