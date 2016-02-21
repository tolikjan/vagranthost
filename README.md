# Vagrant Box with LAMP stack

This Vagrant Box is a simple __Ubuntu Trusty64__ vagrant configuration for LAMP stack (Linux + Apache2 + MySQL + PHPMyAdmin), which also includes some modern development tools.




# Overview
This Vagrant Box using [ubuntu/trusty64](https://atlas.hashicorp.com/ubuntu/boxes/trusty64) from [Atlas Vagrant Box](https://atlas.hashicorp.com/boxes/search?utm_source=vagrantcloud.com&vagrantcloud=1).
  On your `vagrant up` command, this `Vagrantfile` will automatically download the box.

  You need to place your projects in `/var/www/vagranthost` directory. This directory is synced with `/var/www/html` directory in the virtual machine. 
  This project folder also contain a `shells` folder with shell scripts which is used during the provisioning. 

This vagrant box is configured to use `2048 Mb` of RAM and `2 CPU`. You can change these configuration in `Vagrantfile`.
 
### Included packages

- Ubuntu Trusty64 (64-Bit)
- SSH server
- NGINX web server _1.1.19_
- PHP _v5.5.9_ with php5-fpm php5-mysql php5-cli php5-curl php5-gd php5-mcrypt php5-xdebug packages
- MySQL _5.5.47-0_
- PHPMyAdmin _4.0.10deb1_
- Git _v1.9.1_ with tig tool
- Composer _v1.0-dev_

### Included Dependencies
The following dependencies are installed using `apt-get` as they are required to install and build other modules:

- cURL
- python-software-properties
- build-essential




# Installation

### Install via Git
To use Vagrant Box, you should:
1) go to `/var/www/` folder in Terminal (you can use other folder, for this you need configure `config.vm.synced_folder` inside `Vagrantfile`):

    $ cd /var/www
    
2) clone this GitHub Repo with command (use `sudo` if you in protected folder):

    $ sudo git clone https://github.com/tolikjan/vagranthost

### Usage
Start the VM with commands below (use `sudo` if you in protected folder):

    $ cd /var/www/vagranthost
    $ sudo vagrant up

First time of your `vagrant up` will get `Ubuntu_64x` image and provision the vagrant (install all needed dependencies).
After provision you should connect to you machine with (use `sudo` if you in protected folder):

    $ sudo vagrant ssh
    
You can see the status of your VM with URL — [http://192.168.33.10](http://192.168.33.10)
You can check the `phpinfo` from  [http://192.168.33.10/phpinfo.php](http://192.168.33.10/phpinfo.php)

### Requirements
You must have [Vagrant](http://vagrantup.com) and [VirtualBox 5](https://www.virtualbox.org) installed on your host PC.




# Default Credentials
Here are credentials which set up by default.

### Host Address
- Host: 192.168.33.10
you can change in `Vagrantfile` if you like
 
### SSH
- Username: vagrant
- Password: vagrant
- Port: 22

### MySQL Credentials
- Username: root
- Password: root
- Host: localhost
- Port: 3306

### PHPMyAdmin
- URL: 192.168.33.10/phpmyadmin
- Username: root
- Password: root

### Host Configuration
- ONGOING: will be implemented in `config` folder




#### Disclaimer
This `Vagrantfile` and provision was tested on Ubuntu Desktop 14.04.3 64x.
