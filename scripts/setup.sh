#!/bin/bash

# Move index.html and server.php to /var/www/html
sudo mv index.html /var/www/html
sudo mv server.php /var/www/html
sudo mkdir /var/www/html/uploads
sudo chmod 777 /var/www/html/uploads

# Install Apache and Nginx
sudo apt update
sudo apt install -y apache2
sudo apt install -y nginx

# Change Apache listening port from 80 to 8080
APACHE_PORTS_CONF="/etc/apache2/ports.conf"
APACHE_SITES_AVAILABLE="/etc/apache2/sites-available/000-default.conf"

change_apache_port() {
    local conf_file=$1
    local old_port=$2
    local new_port=$3

    sudo sed -i "s/Listen $old_port/Listen $new_port/" "$conf_file"
}

update_virtual_host() {
    local conf_file=$1
    local old_port=$2
    local new_port=$3

    sudo sed -i "s/<VirtualHost *:$old_port>/<VirtualHost *:$new_port>/" "$conf_file"
}

change_apache_port "$APACHE_PORTS_CONF" 80 8080
update_virtual_host "$APACHE_SITES_AVAILABLE" 80 8080

sudo systemctl restart apache2

# Create Nginx config file
#!/bin/bash

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