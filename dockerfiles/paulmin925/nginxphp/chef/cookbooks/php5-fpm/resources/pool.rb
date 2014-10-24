require 'resolv'

actions :create, :delete, :modify
default_action :create if defined?(default_action)

#Overwrite for file replacement
attribute :overwrite, :kind_of => [ TrueClass, FalseClass ], :default => false

#Base Pool Configuration
attribute :pool_name, :name_attribute => true, :kind_of => String, :required => true
attribute :pool_user, :kind_of => String, :required => false, :default => 'www-data'
attribute :pool_group, :kind_of => String, :required => false, :default => 'www-data'
attribute :listen_address, :kind_of => String, :required => false, :default => '127.0.0.1', :regex => Resolv::IPv4::Regex
attribute :listen_port, :kind_of => Integer, :required => false, :default => 9000
attribute :listen_allowed_clients, :kind_of => String, :required=> false, :default => nil
attribute :listen_owner, :kind_of => String, :required=> false, :default => nil
attribute :listen_group, :kind_of => String, :required=> false, :default => nil
attribute :listen_mode, :kind_of => String, :required=> false, :default => nil

#PM Configuration
attribute :pm, :kind_of => String, :required => false, :default => 'dynamic'
attribute :pm_max_children, :kind_of => Integer, :required => false, :default => 10
attribute :pm_start_servers, :kind_of => Integer, :required => false, :default => 4
attribute :pm_min_spare_servers, :kind_of => Integer, :required => false, :default => 2
attribute :pm_max_spare_servers, :kind_of => Integer, :required => false, :default => 6
attribute :pm_process_idle_timeout, :kind_of => String, :required => false, :default => '10s'
attribute :pm_max_requests, :kind_of => Integer, :required => false, :default => 0
attribute :pm_status_path, :kind_of => String, :required => false, :default => '/status'

#Ping Status
attribute :ping_path, :kind_of => String, :required => false, :default => '/ping'
attribute :ping_response, :kind_of => String, :required => false, :default => '/pong'

#Logging
attribute :access_format, :kind_of => String, :required => false, :default => '%R - %u %t \"%m %r\" %s'
attribute :request_slowlog_timeout, :kind_of => Integer, :required => false, :default => 0
attribute :request_terminate_timeout, :kind_of => Integer, :required => false, :default => 0
attribute :access_log, :kind_of => String, :required => false, :default => nil
attribute :slow_log, :kind_of => String, :required => false, :default => nil

#Misc
attribute :chdir, :kind_of => String, :required => false, :default => '/'
attribute :chroot, :kind_of => String, :required => false, :default => nil
attribute :catch_workers_output, :kind_of => String, :required => false, :equal_to => ['yes', 'no'], :default => 'no'
attribute :security_limit_extensions, :kind_of => String, :required => false, :default => '.php'
attribute :rlimit_files, :kind_of => Integer, :required => false, :default => nil
attribute :rlimit_core, :kind_of => Integer, :required => false, :default => nil

attr_accessor :exists
