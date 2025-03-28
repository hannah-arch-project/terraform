#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable php8.0
sudo yum install -y php php-mysqlnd httpd mariadb

cd /var/www/html

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz

sudo cp -r wordpress/* .
sudo cp wordpress/wp-config-sample.php wp-config.php

sudo rm -rf wordpress latest.tar.gz

# wp-config 수정
sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_user}/" wp-config.php
sed -i "s/password_here/${db_pass}/" wp-config.php
sed -i "s/localhost/${rds_endpoint}/" wp-config.php

sudo chown -R apache:apache /var/www/html

sudo systemctl enable httpd
sudo systemctl start httpd