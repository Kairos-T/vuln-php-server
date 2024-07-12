#!/bin/bash

#######################################
# This script changes the Apache      #
# listening port from the default     #
# 80 to 8080                          #
#######################################

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
