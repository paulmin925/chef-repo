#
# Cookbook Name:: php5-fpm
# Recipe:: install
#
# Copyright 2014, Stajkowski
#
# All rights reserved - Do Not Redistribute
#
#     _       _       _       _       _       _       _    
#   _( )__  _( )__  _( )__  _( )__  _( )__  _( )__  _( )__ 
# _|     _||     _||     _||     _||     _||     _||     _|
#(_ P _ ((_ H _ ((_ P _ ((_ - _ ((_ F _ ((_ P _ ((_ M _ (_ 
#  |_( )__||_( )__||_( )__||_( )__||_( )__||_( )__||_( )__|
if RUBY_VERSION > "1.9"
  Encoding.default_external = Encoding::UTF_8
end

#Configure REPO for Debian 6.x
if node[:platform].include?("debian") && node[:platform_version].include?("6.")

    #Install php5-fpm repo Debian 6.x
    cookbook_file "/etc/apt/sources.list.d/dotdeb.list" do
        source "dotdeb.list"
        path "/etc/apt/sources.list.d/dotdeb.list"
        action :create
    end

    #Install GPG Key Debian 6.x
    bash "Add GPG Key Debian 6.x" do
        code "wget http://www.dotdeb.org/dotdeb.gpg; apt-key add dotdeb.gpg"
        action :run
    end

    #Flag for update
    update_flag = true

elsif node[:platform].include?("centos") && node[:platform_version].include?("6.")

    #Install RPMForge Key CentOS 6.x
    bash "Add RPMForge Key CentOS 6.x" do
        code "rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt"
        action :run
    end

    #Install RPMForge Repo
    cookbook_file "/etc/yum.repos.d/rpmforge.repo" do
        source "rpmforge.repo"
        path "/etc/yum.repos.d/rpmforge.repo"
        action :create
    end

    #Remove PHP Common 5.3.3
    package "php-common" do
        action :remove
    end

    #Flag for update
    update_flag = true

elsif node[:platform].include?("ubuntu") && node[:platform_version].include?("10.04")

    #Install Python Software Props Ubuntu 10.04
    package "python-software-properties" do
        action :install
    end

    #Install php5-fpm repo Ubuntu 10.04
    cookbook_file "/etc/apt/sources.list.d/brianmercer.list" do
        source "brianmercer.list"
        path "/etc/apt/sources.list.d/brianmercer.list"
        action :create
    end

    #Install Key Ubuntu 10.04
    bash "Add Key Ubuntu 10.04" do
        code "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8D0DC64F"
        action :run
    end

    #Create FPM.d Directory Ubuntu 10.04
    directory node[:php_fpm][:pools_path] do
        mode 0755
        action :create
        recursive true
    end

    #Flag for update
    update_flag = true

end

#Check if we are updating the Repos and System
if node[:php_fpm][:update_system] || update_flag

    #Select Platform
    case node[:platform]
    when "ubuntu", "debian"

        #Do apt-get update
        bash "Run apt-get update" do
            code "apt-get update"
            action :run
        end

        #Check if we are upgrading the system as well
        if node[:php_fpm][:upgrade_system]

            #Do apt-get upgrade
            bash "Run apt-get upgrade" do
                code "DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y"
                action :run
            end

        end

    when "centos", "redhat", "fedora"

        #Do yum check-update
        bash "Run yum check-update" do
            code "yum check-update"
            returns [0, 100]
            action :run
        end

        #Check if we are upgrading the system as well
        if node[:php_fpm][:upgrade_system]

            #Do yum update -y
            bash "Run yum update" do
                code "yum update -y"
                action :run
            end

        end

    end

end

#Install PHP Modules if Enabled
node[:php_fpm][:php_modules].each do |install_packages|
    package install_packages do
        action :install
        only_if { node[:php_fpm][:install_php_modules] }
    end
end

#Install PHP-FPM Package - Don't install if CentOS, it will be installed above as part of the module listing.
package node[:php_fpm][:package] do
    action :install
end

ruby_block "update listener" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/php5/fpm/pool.d/www.conf")
    fe.search_file_replace_line(/^listen\s\S./, "listen = /var/run/php5-fpm.sock")
    fe.write_file
  end
end

ruby_block "update permissions" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/php5/fpm/pool.d/www.conf")
    fe.insert_line_if_no_match(/^listen.owner./, "listen.owner = www-data")
    fe.insert_line_if_no_match(/^listen.group./, "listen.group = www-data")
    fe.insert_line_if_no_match(/^listen.mode./, "listen.mode = 0660")
    fe.write_file
  end
end


#Enable and Restart PHP5-FPM
service node[:php_fpm][:package] do
    #Bug in 14.04 for service provider. Adding until resolved.
    if (platform?('ubuntu') && node['platform_version'].to_f >= 14.04)
        provider Chef::Provider::Service::Upstart
    end
    supports :start => true, :stop => true, :restart => true, :reload => true
    action [ :enable, :restart ]
end
