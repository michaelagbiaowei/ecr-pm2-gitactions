#!/bin/bash

#Install node and npm
if ! command -v node &> /dev/null;
then 
    echo "Node not installed... Installing node"
    curl -sL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt update; sudo apt install nodejs -y
    node -v
    sudo npm install -g npm@latest
    npm -v

else
    echo "Node is installed... Skipping node isnatllation"
fi

#Check if pm2 is installed
if ! command -v pm2 &> /dev/null;
then
    echo "pm2 is not installed. Installing pm2..."

    npm install pm2@latest -g

    if command -v pm2 &> /dev/null;
    then
        echo "pm2 successfully installed."
    else
        echo "pm2 installation failed."
    fi
else
    echo "pm2 is already installed."
fi

#Verify pm2 version
pm2 -v

# Step 1: Update server
sudo apt update

# Step 2: Check if nginx is installed, if not, install it
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Installing now..."
    sudo apt install nginx -y
    sudo systemctl enable nginx
    sudo systemctl start nginx
    sudo systemctl status nginx
else
    echo "Nginx is already installed. Skipping installation."
fi