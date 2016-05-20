#!/usr/bin/env bash

###################################
#          Other Packages         #
###################################

# Installing SSH
apt-get update > /dev/null 2>&1
apt-get install openssh-client -y > /dev/null 2>&1
apt-get install openssh-server -y > /dev/null 2>&1

# Installing Git
echo "Installing Git"
apt-get install git -y > /dev/null 2>&1
# Use tig utility for better performance of Git from terminal
apt-get install tig -y > /dev/null 2>&1

# Installing Composer
echo "Installing Composer"
apt-get update > /dev/null 2>&1
apt-get install curl php5-cli php5-curl -y > /dev/null 2>&1
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer > /dev/null 2>&1
chmod 777 -R ~/.composer/
# Add code sniffer support:
composer global require drupal/coder
