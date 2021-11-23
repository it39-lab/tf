#!/bin/bash
yum update -y 
yum install -y httpd
echo "web-server-2" > /var/www/html/index.html
sudo service httpd start 
