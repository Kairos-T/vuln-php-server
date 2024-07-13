#!/bin/bash

# Install Apache and Nginx
sudo apt update
sudo apt install -y apache2
sudo apt install -y nginx

# Create Nginx config file

DOMAIN="server.cure51.com"
SERVER_IP="192.168.1.2"
SERVER_PORT="8080"

sudo apt update
sudo apt install -y nginx

# Create Nginx config file
sudo tee /etc/nginx/sites-available/$DOMAIN > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://$SERVER_IP:$SERVER_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

sudo systemctl reload nginx