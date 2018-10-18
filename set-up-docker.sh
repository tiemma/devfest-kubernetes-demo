#!/bin/bash

apt update 

dpkg -i docker.deb 

apt install -f -y 

echo "User is $USER"

usermod -aG docker $USER

