#!/bin/bash

sudo apt-get update && sudo apt-get -y install apache2

sudo apt-get -y install xfce4 xfce4-goodies tightvncserver

echo "Szymon19" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

vncserver

sudo systemctl start apache2

echo '<!doctype html><html><body><h1>Hello You Successfully was able to run a webserver on GCP with Terraform!</h1></body></html>' | sudo tee /var/www/html/index.html
