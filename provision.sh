#!/bin/bash

#update the system packages---------

apt update -y && sudo apt upgrade -y

#install docker--------
if ! command -v docker &> /dev/null
then echo "docker not found. Installing docker"

	apt install docker.io -y

else echo "docker is already installed"
fi

#start docker service
systemctl start docker

#enable docker
systemctl enable docker

#add current docker group
usermod -aG docker ubuntu

#install docker-compose
if ! command -v docker-compose &> /dev/null
then echo "docker-compose not found. Installing.."

apt install docker-compose

echo "docker compose installed successfully"

else 
echo " docker is already installed"
fi

#confirm the two installations
docker --version
docker-compose --version

#install awscli

if ! command -v aws &> /dev/null 
then echo "Installing AWS CLI..."
	sudo apt install awscli -y 
else echo "AWS CLI already installed" 
fi

#create the volume directory
mkdir -p /mnt/mysql-data

#format the EBS volume
sudo mkfs -t ext4 /dev/nvme1n1

#mount the ebs volume
sudo mount /dev/nvme1n1 /mnt/mysql-data

#check if it has been mounted
df -h | grep mysql-data

# change the permission
sudo chown -R ubuntu:ubuntu /mnt/mysql-data
sudo chmod -R 755 /mnt/mysql-data

# restart docker
sudo systemctl restart docker

echo "setup completed successfully"




