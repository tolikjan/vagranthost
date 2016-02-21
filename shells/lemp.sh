#!/usr/bin/env bash

###################################
#         Installing NGINX        #
###################################

apt-get update > /dev/null 2>&1
apt-get install nginx -y > /dev/null 2>&1
service nginx stop > /dev/null 2>&1
# Backup default settings for nginx.conf
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup > /dev/null 2>&1
# Configure nginx.conf
sed -i 's/^worker_processes 4;/worker_processes 1;/' /etc/nginx/nginx.conf > /dev/null 2>&1
# Backup default settings for nginx
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup > /dev/null 2>&1
# Configure nginx for http://localhost/
echo "Configuring Nginx"
cp /var/www/vagranthost/config/default /etc/nginx/sites-available/default > /dev/null 2>&1
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/ > /dev/null 2>&1
service nginx restart > /dev/null 2>&1
# Add site name to /etc/hosts
echo "127.0.0.1       local.vagrant" >> /etc/hosts

###################################
#          Installing PHP         #
###################################

echo "Updating PHP repository"
apt-get install python-software-properties build-essential -y > /dev/null
add-apt-repository ppa:ondrej/php5 -y > /dev/null
apt-get update > /dev/null

echo "Installing PHP"
apt-get install php5 php5-fpm php5-mysql php5-cli php5-curl php5-gd php5-mcrypt php5-xdebug -y > /dev/null 2>&1
# php.ini error reporting configuring
sed -i 's/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php5/fpm/php.ini
sed -i 's/^display_errors = Off/display_errors = On/' /etc/php5/fpm/php.ini
sed -i 's/^display_startup_errors = Off/display_startup_errors = On/' /etc/php5/fpm/php.ini
sed -i 's/^html_errors = Off/html_errors = On/' /etc/php5/fpm/php.ini
sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php5/fpm/php.ini
# Change configuration if you planing to load big files
sed -i 's/^post_max_size = 8M/post_max_size = 200M/' /etc/php5/fpm/php.ini
sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 200M/' /etc/php5/fpm/php.ini
# Set up xdebug variable
xdebug=$(find / -name "xdebug.so" 2> /dev/null)
sleep 120
echo 'zend_extension_ts=\"${xdebug}\"' >> /etc/php5/fpm/php.ini
echo 'xdebug.remote_autostart=1' >> /etc/php5/fpm/php.ini
echo 'xdebug.remote_enable=1' >> /etc/php5/fpm/php.ini
echo 'xdebug.remote_connect_back=1' >> /etc/php5/fpm/php.ini
echo 'xdebug.remote_port=9002' >> /etc/php5/fpm/php.ini
echo 'xdebug.idekey=PHP_STORM' >> /etc/php5/fpm/php.ini
echo 'xdebug.scream=0' >> /etc/php5/fpm/php.ini
echo 'xdebug.cli_color=1' >> /etc/php5/fpm/php.ini
echo 'xdebug.show_local_vars=1' >> /etc/php5/fpm/php.ini
echo ';var_dump display' >> /etc/php5/fpm/php.ini
echo 'xdebug.var_display_max_depth = 5' >> /etc/php5/fpm/php.ini
echo 'xdebug.var_display_max_children = 256' >> /etc/php5/fpm/php.ini
echo 'xdebug.var_display_max_data = 1024' >> /etc/php5/fpm/php.ini
# Change settings for unix socket
sed -i 's/^listen =  127.0.0.1:9000/listen = \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf > /dev/null 2>&1
# Restart services
service mysql restart > /dev/null 2>&1
service nginx restart > /dev/null 2>&1
service php5-fpm restart > /dev/null 2>&1

###################################
#  Installing MySQL & phpmyadmin  #
###################################

apt-get update > /dev/null 2>&1
apt-get install debconf-utils -y > /dev/null 2>&1
# Set up root access to MySQL and phpmyadmin and install it
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections > /dev/null 2>&1
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections > /dev/null 2>&1
apt-get install mysql-server php5-mysql phpmyadmin -y > /dev/null 2>&1
ln -s /usr/share/phpmyadmin /usr/share/nginx/html
# Enable mcrypt and restart service
php5enmod mcrypt > /dev/null 2>&1
service php5-fpm restart > /dev/null 2>&1
