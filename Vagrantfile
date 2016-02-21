# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

# Config
hostname      = "vagranthost"
server_ip     = "192.168.33.10"
server_cpus   = "2"    # Cores
server_memory = "2048" # MB

server_timezone  = "UTC"

# Database Configuration
mysql_root_password = "root"  # we'll assume user "root"
mysql_enable_remote = "true"  # remote access enabled when true
phpmyadmin_password = "root"

# Languages and Packages
php_timezone = "UTC"    # http://php.net/manual/en/timezones.php

Vagrant.configure(2) do |config|

    # Specify the base box
    config.vm.box = "ubuntu/trusty64"

    # Create a hostname, don't forget to put it to the `hosts` file
    # This will point to the server's default virtual host
    config.vm.hostname = hostname

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    config.vm.network :private_network, ip: server_ip

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network :public_network

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    config.ssh.forward_agent = true

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    config.vm.synced_folder "/var/www/vagranthost" , "/usr/share/nginx/html",
        group: "www-data",
        owner: "vagrant",
        mount_options: ['dmode=777', 'fmode=777']
    
    # Replicate local .gitconfig file if it exists
    if File.file?(File.expand_path("~/.gitconfig"))
        config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
    end

    # If using VirtualBox
    config.vm.provider :virtualbox do |vb|

        vb.name = hostname
    
        # Set server cpus
        vb.customize ["modifyvm", :id, "--cpus", server_cpus]

        # Set server memory
        vb.customize ["modifyvm", :id, "--memory", server_memory]
    end

    # Avoids 'stdin: is not a tty' error.
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # PROVISION
    config.vm.provision :shell, inline: "echo Provisioning virtual machine..."

    # Provision Base Packages
    config.vm.provision :shell, path: "shells/base.sh", args: [server_timezone]

    # Provision Extra Package
    config.vm.provision :shell, path: "shells/extra.sh"

    # Provision LEMP
    config.vm.provision :shell, path: "shells/lamp.sh"

    config.vm.provision :shell, inline: "echo Finished provisioning."
end
