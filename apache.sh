#!/bin/bash
yum update -y 
yum install -y httpd
echo "web-server-1" > /var/www/html/index.html
sudo service httpd start 
