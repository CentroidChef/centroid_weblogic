#
# Cookbook:: centroid_weblogic
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# create the necessary groups and users
group node['centroid_weblogic']['os_group'] do
  action :create
end

user node['centroid_weblogic']['os_user'] do
  comment 'Created by Chef for WebLogic installation'
  gid node['centroid_weblogic']['os_group']
  shell node['centroid_weblogic']['os_shell']
  home node['centroid_weblogic']['os_user_home_dir'] + '/' + node['centroid_weblogic']['os_user']
  manage_home true
  action :create
end

# create /stage folder for any installation files
directory '/stage' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# get weblogic software from repository
remote_file '/stage/fmw_12.2.1.3.0_wls.jar' do
  source 'http://chef-assets.centroid.com/software/weblogic/fmw_12.2.1.3.0_wls.jar'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# get java software from repository
remote_file '/stage/jdk-8u151-linux-x64.tar.gz' do
  source 'http://chef-assets.centroid.com/software/java/jdk-8u151-linux-x64.tar.gz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# create java directory
directory '/java' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# Unpack the JDK into the /java directory
execute 'Unpack JDK' do
  command 'tar xzvf /stage/jdk-8u151-linux-x64.tar.gz --directory /java'
end

# Set this java version into the list of alternatives (it will be the default version on a clean system)
%w( java javac javaws keytool ).each do |file|
  execute "alternatives #{file}" do
    command "alternatives --install /usr/bin/#{file} #{file} /java/jdk1.8.0_151/bin/#{file} 1"
  end
end

# Set correct user and owner of /java directories
execute 'chown java_home' do
  command 'chown -R root:root /java'
end

# create the oracle inventory location under the WebLogic OS user
directory node['centroid_weblogic']['ora_inventory_dir'] do
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  mode 0775
  recursive true
  action :create
end

# Add oraInst.loc to the oracle inventory location
template "#{node['centroid_weblogic']['ora_inventory_dir']}/oraInst.loc" do
  cookbook 'centroid_weblogic'
  source 'oraInst.loc.erb'
  mode 0755
  variables(ora_inventory_dir: node['centroid_weblogic']['ora_inventory_dir'],
            os_group: node['centroid_weblogic']['os_group'])
  action :create
end

# create the middleware home directory
directory node['centroid_weblogic']['middleware_home_dir'] do
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  mode 0775
  recursive true
  action :create
end

# Setup the Weblogic 12c response file for the silent install
template "#{node['centroid_weblogic']['tmp_dir']}/wls_12c.rsp" do
    cookbook 'centroid_weblogic'
    source 'wls_12c.rsp.erb'
    mode 0755
    owner node['centroid_weblogic']['os_user']
    group node['centroid_weblogic']['os_group']
    variables(middleware_home_dir: node['centroid_weblogic']['middleware_home_dir'],
              install_type: node['centroid_weblogic']['install_type'])
end

# Run the installation
execute 'Install WLS' do
  command "#{node['centroid_weblogic']['java_home']}/bin/java -Xmx1024m -Djava.io.tmpdir=#{node['centroid_weblogic']['tmp_dir']} -jar /stage/#{node['centroid_weblogic']['wls_source_filename']} -silent -responseFile #{node['centroid_weblogic']['tmp_dir']}/wls_12c.rsp -invPtrLoc #{node['centroid_weblogic']['ora_inventory_dir']}/oraInst.loc"
  user node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  cwd node['centroid_weblogic']['tmp_dir']
end
