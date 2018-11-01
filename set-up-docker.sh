#!/bin/bash

# Run this script to install docker on a debian setup

#Update the current apt repository
sudo apt-get update


#Install necessary dependencies
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

#Add the docker keys
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

#Add the docker repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

#Update the apt repository
sudo apt-get update

#Install the docker client
sudo apt-get install docker-ce

#Add your current username to the docker groups table
#You need this to be able to access the docker client
sudo usermod -aG docker $USER

#You need to relogin to activate the usermod change
sudo login $USER
