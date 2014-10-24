# php5-fpm Cookbook
___
Adding pools can be done by way of LWRP provider or by modifying JSON directly in the attributes file or overriding the attributes through other methods, environments, roles, etc.  Usage of the receipes beyond ::install is optional and not needed if using the LWRP provider.

When using the JSON option with recipes, if you do not wish to use a configuration value in the JSON attributes, you can simply set it to NOT_SET and it will not be included in the configuration file.  Additionally, you can add more configuration values if they are missing, future proofing the template generation with JSON.

#### Supported Platforms

Debian(6.x+), Ubuntu(10.04+)
CentOS(6.x+), RedHat, Fedora(20+)

No additional packages are required.

Tested Against:

Debian 6.x and above
Ubuntu 10.04 and above
CenOS 6.x and above
Fedora 20

#### Planned Improvements

0.3.1 - Expand on LWRP for Environment Variables



## Attributes
___
### php5-fpm::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["install_php_modules"]</tt></td>
    <td>Boolean</td>
    <td>Install Additional PHP Modules</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["update_system"]</tt></td>
    <td>Boolean</td>
    <td>Update repository information</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["upgrade_system"]</tt></td>
    <td>Boolean</td>
    <td>Perform upgrades to OS</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["create_users"]</tt></td>
    <td>Boolean</td>
    <td>Configure Users</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["users"]</tt></td>
    <td>JSON</td>
    <td>Users/Directories to Add</td>
    <td><tt>Attributes File</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["config"]</tt></td>
    <td>JSON</td>
    <td>PHP-FPM.conf Configuration Values</td>
    <td><tt>Attributes File</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["pools"]</tt></td>
    <td>JSON</td>
    <td>pool.conf Configuration Values</td>
    <td><tt>Attributes File</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["ubuntu1004_config"]</tt></td>
    <td>JSON</td>
    <td>PHP-FPM.conf Configuration Values Ubuntu 10.04 Only</td>
    <td><tt>Attributes File</tt></td>
  </tr>
  <tr>
    <td><tt>["php_fpm"]["ubuntu1004_pools"]</tt></td>
    <td>JSON</td>
    <td>pool.conf Configuration Values Ubuntu 10.04 Only</td>
    <td><tt>Attributes File</tt></td>
  </tr>
</table>




## Resource/Provider
___
### php5_fpm_pool

##### Actions

1. :create
2. :modify
3. :delete

##### Attribute Parameters

```
:overwrite, :kind_of => [ TrueClass, FalseClass ], :default => false
:pool_name, :name_=> true, :kind_of => String, :required => true
:pool_user, :kind_of => String, :required => false, :default => 'www-data'
:pool_group, :kind_of => String, :required => false, :default => 'www-data'
:listen_address, :kind_of => String, :required => false, :default => '127.0.0.1', :regex => Resolv::IPv4::Regex
:listen_port, :kind_of => Integer, :required => false, :default => 9000
:listen_allowed_clients, :kind_of => String, :required=> false, :default => nil
:listen_owner, :kind_of => String, :required=> false, :default => nil
:listen_group, :kind_of => String, :required=> false, :default => nil
:listen_mode, :kind_of => String, :required=> false, :default => nil
:pm, :kind_of => String, :required => false, :default => 'dynamic'
:pm_max_children, :kind_of => Integer, :required => false, :default => 10
:pm_start_servers, :kind_of => Integer, :required => false, :default => 4
:pm_min_spare_servers, :kind_of => Integer, :required => false, :default => 2
:pm_max_spare_servers, :kind_of => Integer, :required => false, :default => 6
:pm_process_idle_timeout, :kind_of => String, :required => false, :default => '10s'
:pm_max_requests, :kind_of => Integer, :required => false, :default => 0
:pm_status_path, :kind_of => String, :required => false, :default => '/status'
:ping_path, :kind_of => String, :required => false, :default => '/ping'
:ping_response, :kind_of => String, :required => false, :default => '/pong'
:access_format, :kind_of => String, :required => false, :default => '%R - %u %t \"%m %r\" %s'
:request_slowlog_timeout, :kind_of => Integer, :required => false, :default => 0
:request_terminate_timeout, :kind_of => Integer, :required => false, :default => 0
:access_log, :kind_of => String, :required => false, :default => nil
:slow_log, :kind_of => String, :required => false, :default => nil
:chdir, :kind_of => String, :required => false, :default => '/'
:chroot, :kind_of => String, :required => false, :default => nil
:catch_workers_output, :kind_of => String, :required => false, :equal_to => ['yes', 'no'], :default => 'no'
:security_limit_extensions, :kind_of => String, :required => false, :default => '.php'
:rlimit_files, :kind_of => Integer, :required => false, :default => nil
:rlimit_core, :kind_of => Integer, :required => false, :default => nil
```

##### Example

```
php5_fpm_pool "example" do
  pool_user "www-data"
  pool_group "www-data"
  listen_address "127.0.0.1"
  listen_port 8000
  listen_allowed_clients "127.0.0.1"
  listen_owner "nobody"
  listen_group "nobody"
  listen_mode "0666"
  overwrite true
  action :create
  notifies :restart, "service[#{node[:php_fpm][:package]}]", :delayed
end
```

```
php5_fpm_pool "example" do
  pool_user "fpm_user"
  pool_group "fpm_group"
  listen_allowed_clients "127.0.0.1"
  pm_max_children 25
  pm_start_servers 10
  pm_min_spare_servers 5
  pm_max_spare_servers 10
  pm_process_idle_timeout "20s"
  pm_max_requests 1000
  pm_status_path "/mystatus"
  ping_path "/myping"
  ping_response "/myresponse"
  overwrite true
  action :modify
  notifies :restart, "service[#{node[:php_fpm][:package]}]", :delayed
end
```



## Recipe Usage

#### php-fpm::install

Install PHP5-FPM. Include `php5-fpm::install` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[php5-fpm::install]"
  ]
}
```

#### php5-fpm::create_user

This will create users and directories for use with pools. Include `php5-fpm::create_user` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[php5-fpm::create_user]"
  ]
}
```

#### php5-fpm::configure_pools

This will create pools based on JSON configuration. Include `php5-fpm::configure_pools` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[php5-fpm::configure_pools]"
  ]
}
```

#### php5-fpm::configure_fpm

This will replace the php-fpm.conf file based on JSON configuration. Include `php5-fpm::configure_fpm` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[php5-fpm::configure_fpm]"
  ]
}
```



## License and Authors
___
Authors: Brian Stajkowski

Copyright 2014 Brian Stajkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
