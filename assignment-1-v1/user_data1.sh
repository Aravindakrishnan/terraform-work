#! /bin/bash
sudo su -
yum update
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello world from instance_1" > /var/www/html/index.html