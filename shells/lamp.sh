#!/usr/bin/env bash

###################################
#   Installing Apache WebServer   #
###################################

# Installing apache2
echo "Installing Apache2"
apt-get install apache2 libapache2-mod-php5 -y > /dev/null 2>&1

# Config servername
echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn > /dev/null 2>&1

# Enable mod_rewrite
a2enmod rewrite > /dev/null 2>&1

# Enable mod_ssl
a2enmod ssl > /dev/null 2>&1


###################################
#        Installing MySQL         #
###################################

apt-get update > /dev/null 2>&1
apt-get install debconf-utils -y > /dev/null 2>&1
# Set password for MySQL root account
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections > /dev/null 2>&1
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections > /dev/null 2>&1
# Set password for phpmyadmin root account
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections > /dev/null 2>&1
# Install mysql-server and phpmyadmin
apt-get install mysql-server php5-mysql phpmyadmin -y > /dev/null 2>&1

# Create informations
mysql_install_db > /dev/null 2>&1

# Allow connections to this server from outside
sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY 'root';"
mysql -uroot -proot -e "FLUSH PRIVILEGES;"

###################################
#   Installing PHP5 and packages  #
###################################

# Installing php5 and extended packages
echo "Installing PHP5 and extended packages"
apt-get install php5 php5-common php5-dev php5-cli php5-gd php5-mcrypt php5-mysql php5-xdebug -y > /dev/null 2>&1

# Enable php5-mcrypt mode
php5enmod mcrypt > /dev/null 2>&1

# php.ini error reporting configuring
sed -i 's/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php5/cli/php.ini
sed -i 's/^display_errors = Off/display_errors = On/' /etc/php5/cli/php.ini
sed -i 's/^display_startup_errors = Off/display_startup_errors = On/' /etc/php5/cli/php.ini
sed -i 's/^html_errors = Off/html_errors = On/' /etc/php5/cli/php.ini
sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php5/cli/php.ini

# Change configuration if you planing to load big files
sed -i 's/^post_max_size = 8M/post_max_size = 200M/' /etc/php5/cli/php.ini
sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 200M/' /etc/php5/cli/php.ini

# Sort directory index
sed -i 's/index.php//' /etc/apache2/mods-enabled/dir.conf > /dev/null 2>&1
sed -i 's/DirectoryIndex/DirectoryIndex index.php/' /etc/apache2/mods-enabled/dir.conf > /dev/null 2>&1

# Set up xdebug variable
xdebug=$(find / -name "xdebug.so" 2> /dev/null)
sleep 120
echo 'zend_extension_ts="${xdebug}"' >> /etc/php5/cli/php.ini
echo 'xdebug.remote_autostart=1' >> /etc/php5/cli/php.ini
echo 'xdebug.remote_enable=1' >> /etc/php5/cli/php.ini
echo 'xdebug.remote_connect_back=1' >> /etc/php5/cli/php.ini
echo 'xdebug.remote_port=9002' >> /etc/php5/cli/php.ini
echo 'xdebug.idekey=PHP_STORM' >> /etc/php5/cli/php.ini
echo 'xdebug.scream=0' >> /etc/php5/cli/php.ini
echo 'xdebug.cli_color=1' >> /etc/php5/cli/php.ini
echo 'xdebug.show_local_vars=1' >> /etc/php5/cli/php.ini
echo ';var_dump display' >> /etc/php5/cli/php.ini
echo 'xdebug.var_display_max_depth = 5' >> /etc/php5/cli/php.ini
echo 'xdebug.var_display_max_children = 256' >> /etc/php5/cli/php.ini
echo 'xdebug.var_display_max_data = 1024' >> /etc/php5/cli/php.ini

# Restart mysql service
service mysql restart > /dev/null 2>&1

# Restart apache2 to reload the configuration
service apache2 restart > /dev/null 2>&1
