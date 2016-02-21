#!/usr/bin/env bash

###################################
#         Set up variables        #
###################################

# site folder path
server_name="local.on.vagranthost"
# www config file
www_conf="/etc/php5/fpm/pool.d/www.conf"
# nginx config file
nginx_conf="/etc/nginx/nginx.conf"
# default nginx config
default_nginx_conf="/etc/nginx/sites-available/default"
# mysql variables
mysql_root_user="root"
mysql_root_password="root"

###################################
#         Installing NGINX        #
###################################

apt-get update > /dev/null 2>&1
apt-get install nginx -y > /dev/null 2>&1
service nginx stop > /dev/null 2>&1



# Backup default settings for nginx.conf
cp ${nginx_conf} ${nginx_conf}.backup > /dev/null 2>&1
# Configure nginx.conf
sed -i 's/^worker_processes 4;/worker_processes 1;/' ${nginx_conf} > /dev/null 2>&1
# Backup default settings for nginx
cp ${default_nginx_conf} ${default_nginx_conf}.backup > /dev/null 2>&1
# Configure nginx for http://localhost/
cat > ${default_nginx_conf} << EOF
server {
    listen   80; ## listen for ipv4; this line is default and implied
    listen   [::]:80 default_server ipv6only=on; ## listen for ipv6

    root /usr/share/nginx/html;
    index index.php index.html index.htm;

    server_name ${server_name};

    location / {
        try_files \$uri \$uri/ /index.php;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    # pass the PHP scripts to FastCGI server listening on the php-fpm socket
    location ~ \\.php\$ {

        fastcgi_split_path_info ^(.+\\.php)(/.+)\$;
        try_files \$uri =404;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        #fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_index index.php;
        include fastcgi_params;
    }

}
EOF
# Add site name to /etc/hosts
echo "127.0.0.1       ${server_name}" >> /etc/hosts

###################################
#          Installing PHP         #
###################################

apt-get install php5 php5-fpm php5-mysql php5-cli php5-curl php5-gd php5-mcrypt php5-xdebug -y > /dev/null 2>&1
# php.ini error reporting configuring
for ini in $(find /etc -name 'php.ini')
do
    sed -i 's/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' ${ini}
    sed -i 's/^display_errors = Off/display_errors = On/' ${ini}
    sed -i 's/^display_startup_errors = Off/display_startup_errors = On/' ${ini}
    sed -i 's/^html_errors = Off/html_errors = On/' ${ini}
    sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' ${ini}
    # Change configuration if you planing to load big files
    sed -i 's/^post_max_size = 8M/post_max_size = 200M/' ${ini}
    sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 200M/' ${ini}
done
# Set up xdebug variable
xdebug=$(find / -name "xdebug.so" 2> /dev/null)
sleep 120
for ini in $(find /etc -name 'php.ini')
do
    echo 'zend_extension_ts=\"${xdebug}\"' >> ${ini}
    echo 'xdebug.remote_autostart=1' >> ${ini}
    echo 'xdebug.remote_enable=1' >> ${ini}
    echo 'xdebug.remote_connect_back=1' >> ${ini}
    echo 'xdebug.remote_port=9002' >> ${ini}
    echo 'xdebug.idekey=PHP_STORM' >> ${ini}
    echo 'xdebug.scream=0' >> ${ini}
    echo 'xdebug.cli_color=1' >> ${ini}
    echo 'xdebug.show_local_vars=1' >> ${ini}
    echo ';var_dump display' >> ${ini}
    echo 'xdebug.var_display_max_depth = 5' >> ${ini}
    echo 'xdebug.var_display_max_children = 256' >> ${ini}
    echo 'xdebug.var_display_max_data = 1024' >> ${ini}
done
# Change settings for unix socket
sed -i 's/^listen =  127.0.0.1:9000/listen = \/var\/run\/php5-fpm.sock/' ${www_conf} > /dev/null 2>&1
# Restart services
service mysql restart > /dev/null 2>&1
service nginx restart > /dev/null 2>&1
service php5-fpm restart > /dev/null 2>&1

###################################
#  Installing MySQL & phpmyadmin  #
###################################

apt-get update > /dev/null 2>&1
# Set up root access to MySQL and phpmyadmin and install it
echo "mysql-server mysql-server/root_password password $mysql_root_password" | debconf-set-selections > /dev/null 2>&1
echo "mysql-server mysql-server/root_password_again password $mysql_root_password" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/app-password-confirm password $mysql_root_password" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $mysql_root_password" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/mysql/app-pass password $mysql_root_password" | debconf-set-selections > /dev/null 2>&1
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections > /dev/null 2>&1
apt-get install mysql-server php5-mysql phpmyadmin -y > /dev/null 2>&1
ln -s /usr/share/phpmyadmin /usr/share/nginx/html
# Enable mycrypt and restart service
php5enmod mcrypt > /dev/null 2>&1
service php5-fpm restart > /dev/null 2>&1
