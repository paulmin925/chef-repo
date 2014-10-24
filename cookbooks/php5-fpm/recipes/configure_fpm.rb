#
# Cookbook Name:: php5-fpm
# Recipe:: configure_fpm
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

#Create Pool Configuration
template "#{node[:php_fpm][:base_path]}/#{node[:php_fpm][:conf_file]}" do
	source "php-fpm.erb"
	action :create
	notifies :restart, "service[#{node[:php_fpm][:package]}]", :delayed
end