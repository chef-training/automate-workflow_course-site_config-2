#
# Cookbook:: site_config-2
# Recipe:: default
#
# Copyright:: (c) 2016 The Authors, All Rights Reserved.

include_recipe 'base_web'

template '/etc/apache2/apache2.conf' do
  source 'apache2.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[apache2]'
end

ruby_block 'fix_encoding' do
  block do
    Encoding.default_internal = nil
  end
end

tarball = "#{Chef::Config[:file_cache_path]}/webfiles.tar.gz"

remote_file tarball do
  owner 'root'
  group 'root'
  mode '0644'
  source 'https://s3.amazonaws.com/binamov-delivery/webfiles.tar.gz'
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
  owner 'www-data'
  group 'www-data'
  sensitive true
end

execute 'extract web files' do
  command "tar -xvf #{tarball} -C /var/www/html/"
  not_if do
    ::File.exist?('/var/www/favicon.ico')
  end
end

service 'apache2' do
  supports status: true
  action [:enable, :start]
end
