#!/bin/bash

sudo apt update -y;
sudo apt upgrade -y;
sudo apt install apache2 mariadb-server mariadb-client php php-gd php-cli php-mysql php-common git  certbot python3-certbot-apache -y;

sudo update-rc.d apache2 enable;

sudo systemctl start mariadb;

# Now run and configure
# sudo mysql_secure_installation
sudo su
mysql -e "UPDATE mysql.user SET Password = PASSWORD('nikita12') WHERE User = 'root'"
mysql -e "DROP USER ''@'localhost'"
mysql -e "DROP USER ''@'$(hostname)'"
mysql -e "DROP DATABASE test"
mysql -e "FLUSH PRIVILEGES"
exit

sudo systemctl restart mariadb;
# TODO: load by git repo
git clone https://github.com/WordPress/WordPress.git;

sudo cp -r WordPress/* /var/www/html/;

sudo chown www-data:www-data -R /var/www/html/;

sudo rm -rf /var/www/html/index.html;

# sudo mysql -u root;

# create database wordpress;
# create user "wpadmin"@"%" identified by "wpadminpass";
# grant all privileges on wordpress.* to "wpadmin"@"%";

echo "drop database wordpress;" | sudo mysql -u root;
echo "create database wordpress;" | sudo mysql -u root;
mysql -e "CREATE USER 'wpadmin'@localhost IDENTIFIED BY 'wpadminpass';"
mysql -e "grant all privileges on wordpress.* to 'wpadmin'@localhost;"
#TODO: change file

#sudo sed 's/example.org/example.org/g' /etc/apache2/sites-available/nikitasdomain.tk.conf
#sudo sed 's/webmaster@localhost/webmaster@nikitasdomain.tk                ServerName nikitasdomain.tk/g' /etc/apache2/sites-available/default-ssl.conf
#sudo sed 's/ssl-cert-snakeoil.pem/apache-selfsigned.crt/g' /etc/apache2/sites-available/default-ssl.conf
#sudo sed 's/ssl-cert-snakeoil.key/apache-selfsigned.key/g' /etc/apache2/sites-available/default-ssl.conf
#sudo sed 's/#ServerName www.example.com/Redirect "/" "https://nikitasdomain.tk/"/g' /etc/apache2/sites-available/000-default.conf
#sudo sed 's/example.org/example.org/g' /etc/apache2/sites-available/nikitasdomain.tk.conf

echo "<VirtualHost *:80>
          ServerAdmin webmaster@localhost
          ServerName nikitasdomain.tk
          ServerAlias www.nikitasdomain.tk
          DocumentRoot /var/www/html
          ErrorLog ${APACHE_LOG_DIR}/error.log
          CustomLog ${APACHE_LOG_DIR}/access.log combined
      </VirtualHost>" >> /etc/apache2/sites-available/nikitasdomain.tk.conf
#TODO: check config
sudo apache2ctl configtest

sudo systemctl reload apache2

sudo certbot --apache --non-interactive --agree-tos --domains nikitasdomain.tk --email darty.vis@gmail.com


